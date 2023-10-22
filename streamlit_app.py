import streamlit as st 
import pandas as pd
from PIL import Image # Le ponemos una imagen
import googlemaps
from datetime import datetime
import gmaps
import gmaps.datasets
import folium 
import streamlit_folium as sf
import plotly.express as px

gmaps = googlemaps.Client(key='AIzaSyAV_Qcd4VnnyuDONryfKe6CjwovLjzcjqI')
pd.options.plotting.backend = "plotly"

st.set_page_config(page_title="El Camino INCA", layout="wide", initial_sidebar_state="expanded")
rutas = pd.read_excel('data/RutasDistanciaytiempo.xlsx')
coordenadas = pd.read_excel('data/Coordenadas.xlsx')

# UI text strings 
page_title = "El Camino INCA"
page_helper = "El Camino INCA es una aplicacion que te permitira generar tus rutas de turismo con consciencia ecologica, generanlo la menor huella de carbono posible."
route_search_header = "Seleccione una Ruta"
people_traveling_header = "Ingrese el numero de Personas que viajaran"
transport_type_header = "Seleccione el tipo de transporte"
personas = 10
opciones_analisis = ['Introduccion','Ruta 1', 'Ruta 2', 'Ruta 3']
opciones_tipo_trasporte = ['Tren', 'Camion Pesado', 'Taxi o Particular']
descripcion_rutas = ['Cusco - Ollantaytambo(BUS) - AguasCalientes(Tren) - Machu Pichu(Tren)', 'Cusco - Ollantaytambo(BUS) - AguasCalientes(Tren) - Machu Pichu(Bus)', 'Cusco - Central Hidroeléctrica (BUS) - AguasCalientes(Tren) - Machu Pichu(BUS)']
# Demosle un titulo a nuestra aplicacion
st.title(page_title)


# Creemos una barra lateral
with st.sidebar:
    st.header("Buscando Rutas")
    img = Image.open("logo.jpeg")
    st.image(img, use_column_width=True)
    analisis_seleccionado = st.selectbox(label='Por favor seleccione un analisis de la lista.', options=opciones_analisis)
    st.text_input(label="Cuantas personas van a viajar?", placeholder=personas, key="personas")

# Renderizar
def render_page(ruta):
    st.header(descripcion_rutas[ruta-1])
    rutasN = rutas[rutas['ruta']==ruta]
    rutasN.set_index('ruta', inplace=True)
    st.subheader("Distancia: {:.1f}kms".format(rutasN['distanciaMts'].sum()/1000))
    st.subheader("Duracion: {:.1f}Hrs".format(rutasN['DuracionMin'].sum()/60))
    st.dataframe(rutasN)
    st.subheader("Mapa de la Ruta")
    coordenadasN = coordenadas[coordenadas['ruta']==ruta]
    coordenadasN.set_index('ruta', inplace=True)
    columnas = ['tramo','nombreLugarInicial', 'tipo','vehiculo']
    st.dataframe(coordenadasN[columnas])
    now = datetime.now()
    m = folium.Map(location=[-13.531950, -71.967463], zoom_start=12)
    for idx in range(coordenadasN.shape[0]):
        if coordenadasN.iloc[idx]['vehiculo'] == 'Tren':
            color = 'red'
            transit_mode = 'train'
        elif coordenadasN.iloc[idx]['vehiculo'] == 'Bus':
            color = 'blue'
            transit_mode = 'bus'
        else:
            color = 'green'
        folium.Marker(
            location=[coordenadasN.iloc[idx]['latInicial'], coordenadasN.iloc[idx]['lonInicial']],
            tooltip=coordenadasN.iloc[idx]['nombreLugarInicial']
        ).add_to(m)
        origin = '{},{}'.format(coordenadasN.iloc[idx]['latInicial'],coordenadasN.iloc[idx]['lonInicial'])
        destination = '{},{}'.format(coordenadasN.iloc[idx]['latFinal'],coordenadasN.iloc[idx]['lonFinal'])
        #print(origin,destination)
        directions_result = gmaps.directions('{}, Cusco, Peru'.format(coordenadasN.iloc[idx]['nombreLugarInicial']), '{}, Cusco, Peru'.format(coordenadasN.iloc[idx]['nombreLugarFinal']), transit_mode=transit_mode, departure_time=now)
        #directions_result = gmaps.directions(origin,destination, transit_mode=transit_mode, departure_time=now)
        #print(directions_result)
        # Extract the steps from the directions
        steps = directions_result[0]['legs'][0]['steps']
        # Create a list of latitude and longitude coordinates for the path
        path = []
        for step in steps:
            path += [(step['start_location']['lat'], step['start_location']['lng']),
                    (step['end_location']['lat'], step['end_location']['lng'])]
        # Add the path to the map using the PolyLine() method
        #print(coordenadas1.iloc[idx]['vehiculo'])
        #print(path)
        if coordenadasN.iloc[idx]['nombreLugarInicial'] != coordenadasN.iloc[idx]['nombreLugarFinal']:
            folium.PolyLine(path, color=color, weight=5, opacity=0.7).add_to(m)
            #print(idx, color)
    sf.folium_static(m)


if analisis_seleccionado == 'Ruta 1':
    render_page(1)
elif analisis_seleccionado == 'Ruta 2':
    render_page(2)
elif analisis_seleccionado == 'Ruta 3':
    render_page(3)
elif analisis_seleccionado == 'Introduccion':
    st.header("Huella ecológica per cápita departamental")
    st.markdown("Analisis de la huella ecológica per cápita departamental")
    huellaCarbono = pd.read_excel('data/huellaEcologica.xlsx')
    huellaCarbono.set_index('periodo', inplace=True)
    opciones_ambito = pd.unique(huellaCarbono['ambito'])
    ambito_seleccionado = st.selectbox("Seleccione el departamento", opciones_ambito)
    datos_filtrados = huellaCarbono[huellaCarbono['ambito']==ambito_seleccionado]
    st.dataframe(datos_filtrados)
    grafica = datos_filtrados.plot.bar(y='huellaCarbono', title='Huella ecológica per cápita departamental: ' + ambito_seleccionado)
    st.plotly_chart(grafica)

    