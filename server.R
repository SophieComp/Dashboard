library(plotly)
library(shiny)
library(shinydashboard)
library(sp)
library(leaflet)
library(raster)
library(rgdal)
library(rgeos)



#Enregistrer les éléments en rds puis lancer que les rds=> beaucoup plus rapide,
#En le plaçant avant le serveur évite de faire tourner le modèle N fois,  mais l'ouvre qu'une seule fois.
lcy<- readRDS("data_RDS/lcy.rds")


###Qualité de la biodiversité:
#Indicateur Diversité des espèces:
Amphi_Rept_Table<-readRDS("data_RDS/Amphi_Rept_Table,rds")
Insectes_Table<-readRDS("data_RDS/Insectes_Table.rds")
Mammiferes_Table<-readRDS("data_RDS/Mammiferes_Table.rds")
Oiseaux_Table<-readRDS("data_RDS/Oiseaux_Table.rds")
Angio<- readRDS("data_RDS/Angio_Table.rds")
Gymno<-readRDS("data_RDS/Gymno_Table.rds")
Pteri<-readRDS("data_RDS/Pteri_Table.rds")

Especes_data <- data.frame(
  commune = Amphi_Rept_Table$Communes[c(31, 49)],
  Amphi_rept = Amphi_Rept_Table$Nbre_Esp[c(31, 49)],
  Insectes = Insectes_Table$Nbre_Esp[c(31, 49)],
  Mammiferes = Mammiferes_Table$Nbre_Esp[c(31, 49)],
  Oiseaux = Oiseaux_Table$Nbre_Esp[c(31, 49)],
  stringsAsFactors = FALSE)


Especes_data$commune<- factor(Especes_data$commune , 
                         levels = unique(Especes_data$commune)[order((
                           Especes_data$Amphi_rept + 
                             Especes_data$Insectes +
                             Especes_data$Mammiferes +
                             Especes_data$Oiseaux), decreasing = FALSE)])

Flore_data<- data.frame(
  commune= Amphi_Rept_Table$Communes[c(31, 49)],
  Angio= Angio$Nbre_Esp,
  Gymno= Gymno$Nbre_Esp,
  Pteri= Pteri$Nbre_Esp,
  stringsAsFactors = FALSE
)


Flore_data$commune<- factor(Flore_data$commune , 
                               levels = unique(Flore_data$commune)[order((Flore_data$Angio +
                                                                          Flore_data$Gymno +
                                                                            Flore_data$Pteri), decreasing = FALSE)])

#Indicateur diversité des milieux:
div_milieuGE<-raster("data_RDS/shdi.tif") #raster
div_milieuGE1<-readRDS("data_RDS/Diversite_milieuGE.rds")

dm_GIREC_Lancy<-readRDS("data_RDS/dm_GIREC_Lancy.rds")
paldmGIRECLancy<- colorNumeric(c("#aff7f7", "#932ef7", "#f71b1b"),domain = NULL, na.color = NA)
labeldm_GIREC<- sprintf("<strong>Quartier: %s</strong><br/>Moyenne: %g",
                        dm_GIREC_Lancy@data$nom, dm_GIREC_Lancy@data$Average_sh)%>%
  lapply(htmltools::HTML)

DM_Lancy_data <- data.frame(
  commune = dm_GIREC_Lancy@data$nom, 
  moyenne = dm_GIREC_Lancy@data$Average_sh,
  frag= dm_GIREC_Lancy@data$Frag,
  stringsAsFactors = FALSE)

DM_Lancy_data$commune<- factor(DM_Lancy_data$commune, 
                         levels = unique(DM_Lancy_data$commune)[order
                                                                (DM_Lancy_data$moyenne, decreasing = FALSE)])




# #Indicateur: Corridors de passage
corr_agriGE<-readRDS("data_RDS/corr_AgriGe.rds")

corr_aquaGE<-readRDS("data_RDS/corr_AquaGE.rds")

corr_foretGE<-readRDS("data_RDS/corr_ForetGE.rds")

Corr_Agri_Data<-readRDS("data_RDS/Corr_Agri_Data.rds")

Corr_Aqua_Data<-readRDS("data_RDS/Corr_Aqua_Data.rds")

Corr_Foret_Data<-readRDS("data_RDS/Corr_Foret_Data.rds")

my_data <- data.frame(
  commune = Corr_Agri_Data$Row.Labels, 
  surface_Agri = Corr_Agri_Data$Km2,
  surface_Aqua = Corr_Aqua_Data$Km2,
  surface_Foret = Corr_Foret_Data$Km2,
  stringsAsFactors = FALSE)

my_data$commune<- factor(my_data$commune, 
                         levels = unique(my_data$commune)[order((
                           my_data$surface_Foret +
                           my_data$surface_Agri +
                           my_data$surface_Aqua), decreasing = FALSE)])


#Indicateur: Espèces sur listes rouges
RedListGE<-readRDS("data_RDS/RedListGE.rds")
RedListLancy<-readRDS("data_RDS/RedListLancy.rds")

###Catégorie: Pressions
# Indicateur: Espèces exotiques envahissantes
list_noir<- c(19, 41)
watch_list<- c(6, 17)
autres_especes<- c(637, NA)
Lancy<- c('Lancy', 'Suisse (2014)')

data_EspExo <- data.frame(Lancy, list_noir, watch_list, autres_especes)

# #Indicateur: fragmentation du territoire
frag_shp<-readRDS("data_RDS/frag_shp.rds")
data_frag<-data.frame(commune= frag_shp@data$no_comm,
                      mesh= frag_shp@data$frg_rst)

frag_raster<-raster("data_RDS/frag_raster.tif")

palfragGE<- colorNumeric(c("#f71b1b", "#932ef7", "#aff7f7"),domain = NULL,na.color = NA)

labelfrag_GIREC<-sprintf("<strong>Quartier: %s</strong><br/>Moyenne: %g",
                         dm_GIREC_Lancy@data$nom, dm_GIREC_Lancy@data$Frag)%>%
  lapply(htmltools::HTML)


Frag_Lancy_data <- data.frame(
  commune = dm_GIREC_Lancy@data$nom, 
  frag= dm_GIREC_Lancy@data$Frag,
  stringsAsFactors = FALSE)

Frag_Lancy_data$commune<- factor(Frag_Lancy_data$commune, 
                               levels = unique(Frag_Lancy_data$commune)[order
                                                                      (Frag_Lancy_data$frag, 
                                                                      decreasing = FALSE)])                            

#Indicateur: Pollution lumineuse
poll_lum_Lancy<-raster("data_RDS/LUM_reproject1.tif")

# #Indicateur: Pollution Sonore
bruitRJ_rasterGE<-raster("data_RDS/BruitRouteJ.tif")
bruitRJ_rasterLancy<-raster("data_RDS/bruitRJ_rasterLancy.tif")

bruitRN_rasterGE<-raster("data_RDS/BruitRouteN.tif")
bruitRN_rasterLancy<-raster("data_RDS/bruitRN_rasterLancy.tif")

pal1<-colorNumeric(c("#aff7f7", "#932ef7", "#f71b1b"),domain = NULL, na.color = NA)

Bruit_Jour_Data<-readRDS("data_RDS/Bruit_Jour_Data.rds")
Bruit_Nuit_Data<-readRDS("data_RDS/Bruit_Nuit_Data.rds")

bruit_data <- data.frame(
  commune = Bruit_Nuit_Data$Row.Labels, 
  pourcentage_nuit = Bruit_Nuit_Data$Pourcentage,
  pourcentage_jour = Bruit_Jour_Data$Pourcentage,
  stringsAsFactors = F)

bruit_data$commune<- factor(bruit_data$commune, 
                            levels = unique(bruit_data$commune)[order((
                              bruit_data$pourcentage_jour + 
                                bruit_data$pourcentage_nuit), decreasing = FALSE)])


#Indicateur: Pollution agricole diffuse
azote_tif<-raster("data_RDS/Poll_Azote1.tif")
azoteLancy<-raster("data_RDS/azoteLancy.tif")

phosphoreGE<-raster("data_RDS/phos1.tif")
phosphoreLancy<-raster("data_RDS/phosphoreLancy.tif")

palPollAgri<-colorNumeric(c("#84e26c","#fff714", "#ed931e", "#ff14b8","#ff1414"),domain = NULL, na.color = NA)


#Indicateur: Imperméabilisation du territoire

imper<-readRDS("data_RDS/Imper.rds")
imperLancy<-readRDS("data_RDS/imperLancy.rds")

imper_Graphe<-readRDS("data_RDS/imper_Graphe.rds")
imper_data <- data.frame(
  commune = imper_Graphe$Row.Labels, 
  pourcentage = imper_Graphe$X)

imper_data$commune<- factor(imper_data$commune, 
                         levels = unique(imper_data$commune)[order(imper_data$pourcentage, decreasing = FALSE)])

imper_raster<-readRDS("data_RDS/imper_raster.rds")

###Catégorie: Bénéfices
#Indicateur polliniation:
pollinisateurs_abondanceGE<-raster("data_RDS/abondance_poll.tif")

pollinisateurs_abondanceLancy<-raster("data_RDS/pollinisateurs_abondanceLancy.tif")

palpollinisateurs_abondance<- colorNumeric(c("#45f948","#aff7f7", "#932ef7", "#f71bec","#f71b1b"),
                                       domain= NULL,
                                       na.color = NA)
pollinisation_valeur<-raster("data_RDS/Val_eco.tif")
pollinisation_valeurLancy<- raster("data_RDS/pollinisation_valeurLancy.tif")

#Indicateur carbone:
carboneGE<-raster("data_RDS/carbone_2014_Resample1.tif")

carboneLancy<-raster("data_RDS/carboneLancy.tif")

palcarbone<- colorNumeric(c("#84e26c","#fff714", "#ed931e", "#ff14b8","#ff1414"),
                      domain = NULL,
                      na.color = NA)


carboneBoxplot<-readRDS("data_RDS/Carbone_Boxplot.rds")
carboneBoxplotLancy<-readRDS("data_RDS/Carbone_BoxplotLancy.rds")




###Catégorie: Résultats
#Indicateur Espaces protégés:
EP_Lancy_Graphe<-readRDS("data_RDS/EP_Lancy_Graphe.rds")
EP_Canton_Graphe<-readRDS("data_RDS/EP_Canton_Graphe.rds")

EP_Canton_Pourcentage<-readRDS("data_RDS/EP_Canton_Pourcentage.rds")
data_EP<-data.frame(
  commune= EP_Canton_Pourcentage$Row.Labels,
  pourcentage= EP_Canton_Pourcentage$Pourcentage)

data_EP$commune<-factor(data_EP$commune, 
                          levels = unique(data_EP$commune)[order((data_EP$pourcentage), decreasing = FALSE)])

RN_CONVENTION_RAMSAR<- readRDS("data_RDS/RN_CONVENTION_RAMSAR.rds")
# RN_OBAT_REVISION_2010<- readRDS("data_RDS/RN_OBAT_REVISION_2010.rds") #Intégré dans la couche bas marais
RN_OFEFP_BASMARAIS<- readRDS("data_RDS/RN_OFEFP_BASMARAIS.rds")
RN_OFEFP_IZA<- readRDS("data_RDS/RN_OFEFP_IZA.rds")
RN_OFEFP_PATURAGES_SECS<- readRDS("data_RDS/RN_OFEFP_PATURAGES_SECS.rds")
RN_OFEFP_PAYSAGE<- readRDS("data_RDS/RN_OFEFP_PAYSAGE.rds")
RN_OFEFP_SRB_FIXE<- readRDS("data_RDS/RN_OFEFP_SRB_FIXE.rds")
# RN_OFEFP_SRB_ITINERANT<- readRDS("data_RDS/RN_OFEFP_SRB_ITINERANT.rds") #Intégré dans la couche bas marais
RN_RES_NAT_PLAN_SITE<- readRDS("data_RDS/RN_RES_NAT_PLAN_SITE.rds")

#Indicateur Mesures de compensation:
mesuresGE<-readRDS("data_RDS/MesuresGE.rds")


palMesuresGE<- colorFactor(topo.colors(10), domain= mesuresGE@data$Type_Regroup)

labelsMesuresGE <- sprintf("<strong>Commune: %s</strong><br/>Catégorie: %s </sup>",
                           mesuresGE@data$commune,
                           mesuresGE@data$Type_Regroup)%>%
  lapply(htmltools::HTML)

SC_Graphe<-readRDS("data_RDS/SC_Graphe.rds")
SurfaceCompo_data <- data.frame(
  commune = SC_Graphe$Row.Labels, 
  surface_compensation = SC_Graphe$POURCENTAGE)

SurfaceCompo_data$commune<- factor(SurfaceCompo_data$commune,levels = unique(SurfaceCompo_data$commune)
                                   [order((SurfaceCompo_data$surface_compensation), 
                                          decreasing = FALSE)])

##Investissements pour la biodiversité:
df<- data.frame(
  annee= c(2010, 2011, 2012, 2013, 2014, 2015, 2016,2017,2018, 2019, 2020, 2021),
  Nichoirs= c(1,1,1,1,1,1,1,1,1,1, NA, NA),
  Mesures_Parcs= c(2,2,2,2,2,2,2,2,2,2, NA, NA),
  BIO_Centre= c(NA,NA,NA,NA,NA,NA,NA,3,3,3, NA, NA),
  BIO_Parcs= c(NA,NA,NA,NA,NA,NA,NA,NA,4,4, NA, NA),
  Label_BIO= c(NA,NA,NA,NA,NA,NA,NA,NA,NA,5, 5, 5),
  Futur_Nichoires= c(NA,NA,NA,NA,NA,NA,NA,NA,NA,1, 1, 1),
  Futur_Mesures= c(NA,NA,NA,NA,NA,NA,NA,NA,NA,2,2,2),
  Futur_Centre= c(NA,NA,NA,NA,NA,NA,NA,NA,NA,3,3,3),
  Futur_Parcs= c(NA,NA,NA,NA,NA,NA,NA,NA,NA,4,4,4)
)

##Programmes de sensibilisation:
prog_sensi<-data.frame(
  annee= c(2010, 2011, 2012, 2013, 2014, 2015, 2016,2017,2018, 2018.5, 2019,2020),
  Potager= c(NA, NA, NA, NA, NA, 1, 1, 1, 1, 1, NA, NA),
  Rucher= c(NA, NA, NA, NA, NA, NA, NA, NA, NA,2, 2, 2),
  Futur_Potager= c(NA, NA, NA, NA, NA, NA, NA, NA, NA, 1, 1,1)
)

content1 <- paste(sep = "<br/>",
                 "<b><a href='https://nature.lancy.ch/potager-communal'>Potager communal</a></b>",
                 "Parc Navazza-Oltramare,","1212 Lancy"
)


server<- function(input, output, session){
  
  
  
  ##Graphiques et indicateurs:
  output$qualite1plotly<- renderPlotly({
    plot_ly(
      type = 'scatterpolar',
      mode = "lines+markers"
    ) %>%
      add_trace(
        r = c(36.73453, (100-12.78), (100-19.156241), 13.49, 5.058),
        #pas possible de faire les calculs à la volée donc directement remplacer par les valeurs
        theta = c("Corridors", "Zones <60DB le jour", "Sols perméables", "Espaces protégés",
                  "Surfaces de promotion de la biodiversité"),
        fill = 'toself',
        opacity = 0.7,
        line= list(
          color= 'transparent'
        ),
        name = 'Canton',
        marker = list(
          color = "#626675",
          symbol = 'square',
          size = 8
        ),
        text = "Légende:")%>%
      add_trace(
        r = c(2.80, (100-30.67), (100-57.206763), 5.58, 3.41),
        theta = c("Corridors", "Zones <60DB le jour", "Sols perméables", "Espaces protégés",
                  "Surfaces de promotion de la biodiversité"),
        name = 'Lancy',
        fill = 'toself',
        opacity = 0.7,
        line= list(
          color= 'transparent'
        ),
        marker = list(
          color = "#626675",
          symbol = 'square',
          size = 8
        ),
        text = "Légende:")%>%
      layout(
        legend = list(orientation = 'h'),
        title= "Résumé et comparaison de 5 indicateurs (en %)",
        polar= 
          list(
            domain = list(
              x = c(0,1), #définit leur place sur la feuille de 0 à 1
              y = c(0, 1)
            ),
            radialaxis= list(
              visible= T, 
              range = c(0, 100),#modifier l'échelle pour pouvoir faire une comparaison entre GE et Lancy (mais pas le maximum)
              tickfont = list(
                size = 15 #taille de la police
              )),
            margin = list(r = 150)
          )
          )
  })
  
  output$mapLancy<- renderLeaflet({
    leaflet()%>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldImagery)%>%
      setView(6.12, 46.185, zoom=13) %>%
      addPolygons(data=lcy,fill = FALSE, stroke = TRUE, color = "#03F")
  })
  output$presscliquer<-renderUI({pression})

  ###Indicateur: richesse espèces:
  output$plotEsp<- renderPlotly({
    plot_ly(Especes_data, y= ~Amphi_rept, x= ~commune, type = 'bar', 
            name= 'Amphibiens et reptiles', color = I('#ffb807')
            )%>% 
      add_trace(y = ~Insectes, name = 'Insectes', color = I('#07acff')) %>%
      add_trace(y = ~Mammiferes, name = 'Mammiferes', color = I('#07ff2c')) %>%
      add_trace(y = ~Oiseaux, name = 'Oiseaux', color= I('red'))%>%
      layout(title= "Nombre d'espèces de faune", 
             yaxis = list(title = "Nombre d'espèces"), xaxis= list(title= ""),
             margin = list(l = 150), legend = list(orientation = 'h')) #permet de décaler la marge afin de ne pas couper le nom des légendes en y.
  })
  
  output$plotFlore<- renderPlotly({
    plot_ly(Flore_data, y= ~Angio, x= ~commune, name= 'Angiospermes', color= I('#8a26a8'), type = 'bar'
    )%>% 
      add_trace(y= ~Gymno, name= 'Gymnospermes', color= I('#292584'))%>%
      add_trace(y= ~Pteri, name='Pterydophytes', color= I('#2b8425'))%>%
      layout(title= "Nombre d'espèces de flore", yaxis = list(title = "Nombre d'espèces"), 
             xaxis= list(title= ""), 
             margin = list(l = 150), legend = list(orientation = 'h')) #permet de décaler la marge afin de ne pas couper le nom des légendes en y.
  })

  ###Indicateur: Couloirs de passage
  output$Corr_Agri_Lancy_pourcentage<-renderValueBox({
    valueBox(paste0(format(0,digits=2, nsmall = 2), "%"),
             "Pourcentage du territoire de la commune en corridor agricole", icon = icon("pagelines"), color = "yellow")
    #fonction format((...), digits=2, nsmall=2) permet de dire combien on veut de chiffre après la virgule: ici 2
  })
  output$Corr_Aqua_Lancy_pourcentage<-renderValueBox({
    valueBox(paste0(format(0.81,digits=2, nsmall = 2), "%"),
             "Pourcentage du territoire de la commune en corridor bleu", icon = icon("tint"), color = "blue")
  })
  output$Corr_Foret_Lancy_pourcentage<-renderValueBox({
    valueBox(paste0(format(2.54,digits=2, nsmall = 2), "%"),
             "Pourcentage du territoire de la commune en corridor vert", icon = icon("tree"), color = "green")
  })
  
  output$plotCorr<- renderPlotly({
    plot_ly(my_data[1:47,], x= ~surface_Agri, y= ~commune, type = 'bar', 
            name= 'Agricoles', orientation= 'h', color = I('#ffb807'))%>% 
      add_trace(x = ~surface_Aqua, name = 'Aquatiques', color = I('#07acff')) %>%
      add_trace(x = ~surface_Foret, name = 'Foret', color = I('#07ff2c')) %>%
      layout(yaxis = list(title = 'Communes'), xaxis= list(title='Surface de chaque corridor en fonction de la surface totale de la commune'), barmode = 'group', 
             margin = list(l = 150))
  })
  

  output$corr_mapGE<-renderLeaflet({
    leaflet()%>%
      addTiles() %>%
      addProviderTiles(providers$OpenStreetMap.BlackAndWhite)%>%
      setView(6.12, 46.185, zoom=11) %>%
      addPolygons(data=corr_agriGE,fill = TRUE, stroke = TRUE,
                  fillOpacity=1,
                  color = "#f0b13a", group="Corridors jaunes")%>%
      addPolygons(data=corr_aquaGE,fill = TRUE, stroke = TRUE,
                  fillOpacity=1,
                  color = "blue", group="Corridors bleus")%>%
      addPolygons(data=corr_foretGE,fill = TRUE, stroke = TRUE,
                  fillOpacity=1,
                  color = "green", group="Corridors verts")%>%
      addPolygons(data= lcy, color= "#832429", fill= FALSE, stroke = TRUE, 
                  weight= 2.5, fillOpacity = 1)%>%
      addLayersControl(baseGroups = c("Corridors jaunes", "Corridors verts","Corridors bleus"),
                       options=layersControlOptions(collapsed= FALSE))
  })

  ###Indicateur Diversite des milieux:
  output$plotDiv<- renderPlotly({
    plot_ly( x= div_milieuGE1@data$shdi[div_milieuGE1@data$commune == 'Lancy'], 
             type = 'box', name= 'Lancy', orientation= 'h', color= I('#a50101')
    )%>%
      add_trace(x= div_milieuGE1@data$shdi, name= 'Canton', color= I('#035fa5'))%>%
      layout(yaxis = list(title = ''), xaxis= list(title= 'Indice de Shannon'), title= "Comparaison entre le canton et Lancy", showlegend= F)
  })
  
  output$plotDivLancy<- renderPlotly({
    plot_ly(DM_Lancy_data, x= ~moyenne, y= ~commune, type = 'bar', 
            name= 'Moyenne', orientation= 'h', color = I('#a50101')
    )%>%
      layout(yaxis = list(title = 'GIREC'), title= "Comparaison des différents quartiers sur la commune", barmode = 'group', 
             margin = list(l = 150))
  })

  
  output$div_milieuGIREC<-renderLeaflet({
    leaflet()%>%
      addTiles() %>%
      setView(6.12, 46.185, zoom=13) %>%
      addPolygons(data=dm_GIREC_Lancy,fill = TRUE, stroke = TRUE, opacity= 1,
                  fillOpacity = 1, weight=1,
                  color = paldmGIRECLancy(dm_GIREC_Lancy@data$Average_sh),
                  group= "GIREC",
                  label = labeldm_GIREC,labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px", direction = "auto"))%>%
      addRasterImage(div_milieuGE, group="Canton",
                     colors = paldmGIRECLancy, opacity = 0.9)%>%
      addLegend(pal = paldmGIRECLancy, values = as.numeric(dm_GIREC_Lancy@data$Average_sh),
                                                           group= "GIREC", 
                position= "bottomleft", title= "Valeurs par </br> quartiers")%>%
      addLegend(pal = paldmGIRECLancy,values = values(div_milieuGE),
                group= "Canton", position= "bottomleft", title= "Valeurs pour </br> tout
                le canton")%>%
      addLayersControl(overlayGroups= c("GIREC", "Canton"),
                       options=layersControlOptions(collapsed= FALSE))%>%
      hideGroup("Canton")
  })

  ###Indicateur: Espèces sur listes rouges:
  output$plotRedList1<-renderPlotly({
    plot_ly(RedListGE, x = ~Type, y = ~RE, type = 'bar', name = 'Eteintes', color= I('#5e0000')) %>%
      add_trace(y = ~CR, name = 'En danger critique', color= I('#f12828')) %>%
      add_trace(y = ~EN, name = 'En danger', color= I('#fca105')) %>%
      add_trace(y = ~VU, name = 'Vulnérables', color= I('#f7ec1b')) %>%
      add_trace(y = ~NT, name = 'Quasi menacées', color= I('#9ff71b')) %>%
      add_trace(y = ~LC, name = 'Préoccupation mineure', color= I('#36c439')) %>%
      add_trace(y = ~DD, name = 'Données insuffisantes', color= I('#9b9b9b')) %>%
      add_trace(y = ~NE, name = 'Non évaluées', color= I('#ededed')) %>%
      add_trace(y = ~NonDispo, name = 'Pas de données', color= I('#ffffff')) %>%
      layout(yaxis = list(title = 'Catégories de listes rouge'), xaxis= list(title= ''), 
             legend = list(orientation = 'h'),
             title= "Espèces sur listes rouge sur le canton", margin = list(b = 150), barmode = 'stack')
  })
  
  output$plotRedList2<-renderPlotly({
    plot_ly(RedListLancy, x = ~Type, y = ~RE, type = 'bar', name = 'Eteintes', color= I('#5e0000')) %>%
      add_trace(y = ~CR, name = 'En danger critique', color= I('#f12828')) %>%
      add_trace(y = ~EN, name = 'En danger', color= I('#fca105')) %>%
      add_trace(y = ~VU, name = 'Vulnérables', color= I('#f7ec1b')) %>%
      add_trace(y = ~NT, name = 'Quasi menacées', color= I('#9ff71b')) %>%
      add_trace(y = ~LC, name = 'Préoccupation mineure', color= I('#36c439')) %>%
      add_trace(y = ~DD, name = 'Données insuffisantes', color= I('#9b9b9b')) %>%
      add_trace(y = ~NE, name = 'Non évaluées', color= I('#ededed')) %>%
      add_trace(y = ~NonDispo, name = 'Pas de données', color= I('#ffffff')) %>%
      layout(yaxis = list(title = 'Catégories de listes rouge'), xaxis= list(title= ''), 
             title= "Espèces sur listes rouge </br> </br> dans la commune de Lancy", 
             legend = list(orientation = 'h'),
             margin = list(b = 150), barmode = 'stack')
  })

  ###Catégorie: Pression:
 
  ###Indicateur Especes exotiques envahissantes:
  output$EspExoPlot<- renderPlotly({
    plot_ly(data_EspExo, x = ~Lancy, y = ~list_noir, type = 'bar', name = 'Liste noire') %>%
      add_trace(y = ~watch_list, name = 'Watch Liste') %>%
      #add_trace(y = ~autres_especes, name= 'Autres espèces')%>%
      layout(yaxis = list(title = 'Nombre espèces'), xaxis= list(title= ''), 
             title= "Espèces exotiques envahissantes", barmode = 'stack')
  })
  ###Indicateur Fragmentation:
  output$boxplotFrag<- renderPlotly({
    plot_ly(x= data_frag$mesh[data_frag$commune== '31'], type = "box", name= 'Lancy', color = I('#a50101'))%>%
      add_trace(x= data_frag$mesh, name= 'Canton', color= I('#3c4fbc'))%>%
      layout(yaxis = list(title = ''), xaxis= list(title= 'Mesh'),
             title= "Comparaison de la fragmentation <br> entre la commune et le canton",
             showlegend= F)
  })
  
  output$plotFragGIREC<- renderPlotly({
    plot_ly(Frag_Lancy_data, x=~frag, y= ~commune , type = 'bar', 
            name= 'Moyenne', orientation= 'h', color = I('#a50101')
    )%>%
      layout(yaxis = list(title = 'GIREC'), xaxis= list(title= 'Moyenne de Mesh'),
             title= "Comparaison des différents quartiers sur la commune", barmode = 'group', 
             margin = list(l = 150))
  })
  
  output$fragmap<-renderLeaflet({
    leaflet()%>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldTopoMap)%>%
      setView(6.12, 46.185, zoom=13) %>%
      addRasterImage(frag_raster,colors = palfragGE, group="Fragmentation Canton")%>%
      addPolygons(data= dm_GIREC_Lancy,fill = TRUE, stroke = TRUE, weight= 1, opacity= 1, fillOpacity = TRUE,
                  color = palfragGE(dm_GIREC_Lancy@data$Frag), group="Fragmentation GIREC",
                  label = labelfrag_GIREC,labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px", direction = "auto"))%>%
      addLegend(pal= palfragGE, values= as.numeric(dm_GIREC_Lancy@data$Frag),
                opacity = 0.7, group="Fragmentation GIREC",
                position = "bottomright", title="Valeurs par </br> quartier")%>%
      addLegend(pal= palfragGE, values= values(frag_raster),
                opacity = 0.7, group="Fragmentation Canton",
                position = "bottomright", title="Valeurs pour </br> tout le canton")%>%
      addLayersControl(overlayGroups = c("Fragmentation Canton", "Fragmentation GIREC"),
                       options=layersControlOptions(collapsed= TRUE))%>%
      hideGroup("Fragmentation Canton")
  })
  ###Indicateur impermeabilisation:
  output$imper_Lancy_pourcentage<-renderValueBox({
    valueBox(paste0(format(56.17,digits=2, nsmall = 2), "%"),
             "Pourcentage de la commune imperméable", icon = icon("road"), color = "yellow")
  })

  output$plotImper<- renderPlotly({
    plot_ly(imper_data, x= ~pourcentage[-31], y= ~commune[-31], type = 'bar', 
            name= 'Imperméable', orientation= 'h', color = I('#b57272'))%>%
      add_trace(x= ~pourcentage[31], y= ~commune[31], name= 'Imperméable', color = I('#593737') 
      )%>% #Permet de colorer le résultat pour Lancy d'une autre couleur, pour qu'il ressorte.
      layout(yaxis = list(title = 'Communes'), xaxis= list(title= 'Surface (en %)'), barmode = 'group',
             showlegend= F,
             margin = list(l = 150))
  })


  output$impermap<-renderLeaflet({
    leaflet()%>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldTopoMap) %>%
      setView(6.12, 46.185, zoom=13) %>%
#       addRasterImage(imper_raster, group="Imperméabilisation Canton",
#                      colors = "red", opacity = 0.9)%>% => trop lourde prenait trop de temps et pas assez précise
      addPolygons(data=imperLancy,opacity= 1,
                  fillOpacity = 1, weight=1,
                  color = I('#b57272'), group="Imperméabilisation Commune")%>%
      addLegend(colors= c(I('#b57272')), labels= c("Sols imperméables"), title= "Légende")
  })

  ###Indicateur Pollution sonore:
  output$Bruit_nuitR_pourcentage <-renderValueBox({
    valueBox(paste0(32.67, "%"), "Valeur >= 50dB", icon = icon("star"), color = "purple")
    # valueBox(paste0(format(((sum((as.numeric((ifelse(as.numeric(as.character
    #                                                             (bruitRN_shpLancy@data$gridcode))
    #                                                  >= 50, yes = 1, no=0))))*
    #                                ((bruitRN_shpLancy@data$Shape_Area))))*(100))/
    #                          (sum(bruitRN_shpLancy@data$Shape_Area)),
    #                        digits=2, nsmall = 2), "%"), "Valeur >= 50dB", icon = icon("star"), color = "purple") 
    # => calcul à la volée trop lourd, donc a été remplacé par les valeurs brutes.
  })
  output$Bruit_jourR_pourcentage <-renderValueBox({
    valueBox(paste0(30.67, "%"), "Valeur >= 60dB", icon = icon("circle"), color = "yellow")
    # valueBox(paste0(format(((sum((bruitRJ_shpLancy@data$columYESNO)*(bruitRJ_shpLancy@data$Shape_Area)))*(100))/
    #                          (sum(bruitRJ_shpLancy@data$Shape_Area)),
    #                        digits=2, nsmall = 2), "%"), "Valeur >= 60dB", icon = icon("sun"), color = "yellow")
    #fonction format((...), digits=2, nsmall=2) permet de dire combien on veut de chiffre après la virgule: ici 2
  })
  output$plotBruit<- renderPlotly({
      plot_ly(x= bruit_data$pourcentage_jour, y= bruit_data$commune, type = 'bar', 
              name= 'Bruit jour', orientation= 'h', color = I("#f4930c"))%>%
      add_trace(x = bruit_data$pourcentage_nuit, name = 'Bruit nuit', color= I("#c70ef9")) %>% #ajouter couleur à plotly 
      layout(yaxis = list(title = 'Communes'), xaxis= list(title='Surface (en %)'), barmode = 'group', 
             legend = list(orientation = 'h'),
             margin = list(l = 150))
  })
  output$mapbruitGE<- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldTopoMap)%>%
      setView(6.12, 46.185, zoom=11) %>%
      addRasterImage(bruitRJ_rasterGE, group="Jour",
                     colors = pal1, opacity = 0.9)%>%
      addRasterImage(bruitRN_rasterGE, group="Nuit",
                     colors = pal1, opacity = 0.9)%>%
      addLegend(position= "bottomleft", pal = pal1, values = values(bruitRJ_rasterGE),
                title = "Valeurs Jour:", group="Jour")%>%
      addLegend(position= "bottomleft", pal = pal1, values = values(bruitRN_rasterGE),
                title = "Valeurs Nuit:", group="Nuit")%>%
      addLayersControl(overlayGroups = c("Jour","Nuit"), options=
                       layersControlOptions(collapsed= FALSE))%>%
      hideGroup("Nuit")
  })
  output$mapbruitLANCY<- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldTopoMap)%>%
      setView(6.12, 46.185, zoom=13) %>%
      addRasterImage(bruitRJ_rasterLancy, group="Jour",
                     colors = pal1, opacity = 0.9)%>%
      addRasterImage(bruitRN_rasterLancy, group="Nuit",
                     colors = pal1, opacity = 0.9)%>%
      addLegend(position= "bottomleft", pal = pal1, values = values(bruitRJ_rasterLancy),
                title = "Valeurs Jour:", group="Jour")%>%
      addLegend(position= "bottomleft", pal = pal1, values = values(bruitRN_rasterLancy),
                title = "Valeurs Nuit:", group="Nuit")%>%
      addLayersControl(overlayGroups = c("Jour","Nuit"), options=
                         layersControlOptions(collapsed= FALSE))%>%
      hideGroup("Nuit")
  })

###Indicateur pollution agricole:

  output$mapPollAgriN<-renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldTopoMap)%>%
      setView(6.12, 46.185, zoom=11) %>%
      addRasterImage(azote_tif, group="Canton",
                     colors = palPollAgri, opacity = 0.9)%>%
      addLegend(position= "topleft", pal = palPollAgri,
                values = values(azote_tif),
                title = "Légende:")
  })
  
  output$mapPollAgriP<- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldTopoMap)%>%
      setView(6.12, 46.185, zoom=11) %>%
      addRasterImage(phosphoreGE, group="Azote",
                     colors = palPollAgri, opacity = 0.9)%>%
      addLegend(position= "topleft", pal = palPollAgri,
                values= values(phosphoreGE), labFormat= labelFormat(digits = 10),
                title = "Légende:")
                  
  })
  
  output$azoteGE_boxplot<- renderPlot({
    boxplot(azote_tif, xlab="Canton", ylab="Valeurs", ylim= c(0, 0.012519), col= '#035fa5')
  })
  
  output$azoteLancy_boxplot<- renderPlot({
    boxplot(azoteLancy, xlab="Lancy", ylab="Valeurs", ylim= c(0, 0.012519), col= '#a50101')
  })
  
  output$phosphoreGE_boxplot<- renderPlot({
    boxplot(phosphoreGE, xlab="Canton", ylab="Valeurs", ylim= c(0,  0.000131779), col='#035fa5')
  })
  
  output$phosphoreLancy_boxplot<- renderPlot({
    boxplot(phosphoreLancy, xlab="Lancy", ylab="Valeurs", ylim= c(0,  0.000131779), col= '#a50101')
  })

  ##Indicateur pollution lumineuse
  output$lum <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(6.12, 46.185, zoom=13) %>%
      addRasterImage(poll_lum_Lancy, colors= "Spectral", opacity = 0.9) #couleur choisie: couleurs spectrales du raster
  })

  ###Indicateur pollinisation:
  output$mappollinisateurs_abondance<- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldTopoMap)%>%
      setView(6.12, 46.185, zoom=11) %>%
      addRasterImage(pollinisateurs_abondanceGE, group="Canton GE",
                     colors = palpollinisateurs_abondance, opacity = 0.9) %>%
      addLegend(position= "topleft", pal = palpollinisateurs_abondance,
                values= values(pollinisateurs_abondanceGE), labFormat= labelFormat(digits = 10),
                title = "Légende:")
    
  })
  
  output$abondanceGE_boxplot<- renderPlot({
    boxplot(pollinisateurs_abondanceGE, xlab="Canton", ylab="Valeurs", ylim= c(0, 0.337307), col= '#035fa5')
  })
  
  output$abondanceLancy_boxplot<- renderPlot({
    boxplot(pollinisateurs_abondanceLancy, xlab="Lancy", ylab="Valeurs", ylim= c(0, 0.337307), col= '#a50101')
  })

  output$mappollinisateurs_eco<- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldTopoMap)%>%
      setView(6.12, 46.185, zoom=11) %>%
      addRasterImage(pollinisation_valeur, group= "Canton Valeur",
                     colors= palpollinisateurs_abondance, opacity= 0.9)%>%
      addLegend(position= "topleft", pal = palpollinisateurs_abondance,
                values = values(pollinisation_valeur), labFormat= labelFormat(digits = 10),
                title = "Légende:" )
  })
  
  output$val_ecoGE<- renderPlot({
    boxplot(pollinisation_valeur, xlab="Canton", ylab="Valeurs", ylim= c(0,  0.187853), col= '#035fa5')
  })
  
  output$val_ecoLancy_boxplot<- renderPlot({
    boxplot(pollinisation_valeurLancy, xlab="Lancy", ylab="Valeurs", ylim= c(0,  0.187853), col= '#a50101')
  })
  
  ###Indicateur carbone:
  output$mapcarbone<- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldTopoMap)%>%
      setView(6.12, 46.185, zoom=11) %>%
      addRasterImage(carboneGE, group="Canton GE",
                     colors = palcarbone, opacity = 0.9) %>%
      addRasterImage(carboneLancy, group="Lancy",
                     colors = palcarbone, opacity = 0.9) %>%
      addLayersControl(baseGroups = c("Canton GE", "Lancy"), options=
                         layersControlOptions(collapsed= FALSE))%>%
      addLegend(position= "topleft", pal = palcarbone, labFormat= labelFormat(digits = 10),
                values = values(carboneGE),
                title = "Légende:" )
  })
  
  output$carboneBoxplotGE<- renderPlot({
    boxplot(carboneGE, xlab="Canton", ylab="Valeurs", ylim= c(0, 0.68), col='#035fa5')
  })
  
  output$carboneBoxplotLancy<- renderPlot({
    boxplot(carboneLancy, xlab="Lancy", ylab="Valeurs", ylim= c(0, 0.68), col='#a50101')
  })

  ###Catégorie: Résultats:
 
  ##Indicateur Espaces proteges:
  output$espacesprotvaluebox<-renderValueBox({
    valueBox(paste0(format(EP_Canton_Pourcentage[31, 4],digits=2, nsmall = 2), "%"),
             "Pourcentage territoire Commune", icon = icon("search"), color = "green")
  })
  output$epCantonValueBox<- renderValueBox({
    valueBox(paste0(format(EP_Canton_Pourcentage[49, 4],digits=2, nsmall = 2), "%"),
             "Pourcentage territoire Canton", icon = icon("lock"), color = "blue")
  })
  
  output$pieCanton<- renderPlotly({
    plot_ly(EP_Canton_Graphe, labels= EP_Canton_Graphe$Row.Labels, 
            values= EP_Canton_Graphe$Sum.of.Shape_Area, type= 'pie',
            textposition = 'outside',
            textinfo = 'label+percent',
            hole= 0.6,
            marker = list(colors = colors,
                          line = list(color = '#FFFFFF', width = 2)),
            showlegend= F) %>%
      add_pie(hole = 0.6) %>%
      layout(title = "Types d'espaces protégés dans le Canton",  showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             margin= list(
               l = 100,
               r = 100,
               b = 50,
               pad = 4
             ))  
  })
  
  output$pieLancy<- renderPlotly({
    plot_ly(EP_Lancy_Graphe, labels= EP_Lancy_Graphe$Row.Labels, 
            values= EP_Lancy_Graphe$Sum.of.Shape_Area, type= 'pie',
            textposition = 'outside',
            textinfo = 'label+percent',
            hole= 0.6,
            marker = list(colors = colors,
                          line = list(color = '#FFFFFF', width = 2)),
            showlegend= F) %>%
      layout(title = "Types d'espaces protégés dans la commune",  showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             margin= list(
               l = 100,
               r = 100,
               b = 50,
               pad = 4
             ))  
  })
  output$plotEP<- renderPlotly({
    plot_ly(x= data_EP$pourcentage[-31], y= data_EP$commune[-31], type = 'bar', 
            name= 'Espaces Proteges', orientation= 'h', color = I('#4ab54b')
    )%>%
      add_trace(x= data_EP$pourcentage[31], y= data_EP$commune[31], color = I('#266027'))%>%
      layout(yaxis = list(title = 'Communes'), xaxis= list(title= "Surface (en %)"),
             showlegend= F, margin = list(l = 150))
  })
  output$mapespaces <- renderLeaflet({
    leaflet()%>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldTopoMap)%>%
      setView(6.12, 46.185, zoom=11) %>%
      addPolygons(data= RN_CONVENTION_RAMSAR, color = "#f97070",
                  stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
                  group="Convention Ramsar")%>%
#       addPolygons(data= RN_OBAT_REVISION_2010, color = "#ff9d0a",
#                   stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, group= "OBAT")%>%
      addPolygons(data= RN_OFEFP_BASMARAIS, color = "#9fcc45",
                  stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, group= "BAS MARAIS")%>%
      addPolygons(data= RN_OFEFP_IZA, color = "#24a542",
                  stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, group= "IZA")%>%
      addPolygons(data= RN_OFEFP_PAYSAGE, color = "#23a593",
                  stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, group= "PAYSAGE")%>%
      addPolygons(data= RN_OFEFP_PATURAGES_SECS, color = "#236ca5",
                  stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, group= "PATURAGES SECS")%>%
      addPolygons(data= RN_OFEFP_SRB_FIXE, color = "#042bed",
                  stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, group= "SRB FIXE")%>%
#       addPolygons(data= RN_OFEFP_SRB_ITINERANT, color = "#af15a3",
#                   stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, group= "SRB ITINERANT")%>%
      addPolygons(data= RN_RES_NAT_PLAN_SITE, color = "#f9222c",
                  stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, group= "RES NAT")%>%
      addLayersControl(baseGroups = c("Convention Ramsar", "BAS MARAIS",
                                      "IZA", "PAYSAGE", "PATURAGES SECS",
                                      "SRB FIXE", "RES NAT"),
                       options=layersControlOptions(collapsed= FALSE))
  })


  ##Indicateur Mesures de compensation:
  output$mesuresvaluebox1<-renderValueBox({
    valueBox(paste0(format((179247.6687*100/4775290.795),digits=2, nsmall = 2), "%"),
             "Pourcentage de prairies dans la commune", icon = icon("pagelines"), color = "olive")
  }) 
  
  output$mesuresvaluebox2<-renderValueBox({
    valueBox(paste0(format((3.412891096),digits=2, nsmall = 2), "%"),
             "Pourcentage de SPB dans la commune", icon = icon("lock"), color = "teal")
  })

  
  output$plotSC<- renderPlotly({
    plot_ly(SurfaceCompo_data, x= ~surface_compensation[-31], y= ~commune[-31], type = 'bar', 
            name= 'Surface de compensation', color = I('#007d7d'),
            orientation= 'h')%>%
      add_trace(x = ~surface_compensation[31], y= ~commune[31], color= I('#023535')) %>%
      layout(yaxis = list(title = 'Communes'), xaxis= list(title='Surface de SPB par rapport aux prairies et cultures (en %)'), 
             barmode = 'stack', 
             showlegend= F, 
             margin = list(l = 150, b= 50))
  })
  output$mapmesures<-renderLeaflet({
    leaflet()%>%
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldImagery)%>%
      setView(6.12, 46.185, zoom=12) %>%
      addPolygons(data= mesuresGE, color = ~palMesuresGE(mesuresGE@data$Type_Regroup),
                  stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, group= "Genève",
                  label = labelsMesuresGE,labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px", direction = "auto"))%>% # permet de passer sur la carte et d'avoir la légende chaque polygone.
      addPolygons(data= lcy, color= "#ffffff", fill= FALSE, stroke = TRUE, 
                  weight= 2.5, fillOpacity = 1)%>%
      addLegend(position= "topright", 
                title = "Passez au dessus <br/> de chaque polygone <br/> pour voir la légende",
                colors= "white", labels= "")
  })
  
  ##Indicateur investissements:
  output$timeseries <- renderPlotly({
    p <- plot_ly(data = df, x = ~annee, y = ~Nichoirs, name= "Nichoirs", type = 'scatter', mode = 'lines',
                 line = list(color = 'rgb(22, 96, 167)', width = 4))%>%
      add_lines(y = ~Futur_Nichoires, line = list(color = 'rgb(22, 96, 167)', width = 4, dash= 'dot'), showlegend= F)%>%
      add_lines(y = ~Mesures_Parcs, name= "Mesures dans les parcs", type = 'scatter', mode = 'lines',
                line = list(color = 'rgb(158, 84, 183)', width = 4))%>%
      add_lines(y = ~Futur_Mesures, line = list(color = 'rgb(158, 84, 183)', width = 4, dash= 'dot'), showlegend= F)%>%
      add_lines(y = ~BIO_Parcs, name= "BIO dans les parcs", type = 'scatter', mode = 'lines',
                line = list(color = 'rgb(83, 183, 174)', width = 4))%>%
      add_lines(y = ~Futur_Parcs, line = list(color = 'rgb(83, 183, 174)', width = 4, dash= 'dot'), showlegend= F)%>%
      add_lines(y = ~BIO_Centre, name= "BIO Centre de production", type = 'scatter', mode = 'lines',
                line = list(color = 'rgb(147, 239, 139)', width = 4))%>%
      add_lines(y = ~Futur_Centre, line = list(color = 'rgb(147, 239, 139)', width = 4, dash= 'dot'), showlegend= F)%>%
      add_lines(y = ~Label_BIO, name= "Label BIO", type = 'scatter', mode = 'lines',
                line = list(color = 'rgb(239, 139, 139)', width = 4, dash= 'dot'))%>%
      layout(title= "Investissements pour la biodiversité", hovermode= FALSE,
             xaxis = list(range = c(2010, 2021), title = 'Année'), yaxis= list(showgrid = F, 
                                                        showlegend=F, title= "",
                                                        showticklabels = FALSE))
    
  })
  
  ##Indicateur programmes de sensibilisation:
  output$progsensi<- renderPlotly({
    plot_ly(prog_sensi, x = ~annee, y = ~Potager, name= "Potager", type = 'scatter', mode = 'lines',
            line = list(color = 'rgb(22, 96, 167)', width = 4))%>%
      add_lines(y = ~Rucher, name= "Rucher", line = list(color = 'rgb(121, 22, 167)', width = 4, dash= 'dot')) %>%
      add_lines(y = ~Futur_Potager, name= "Rucher", line = list(color = 'rgb(22, 96, 167)', width = 4, dash= 'dot'), showlegend= F)%>%
      layout(title = "Programmes de sensibilisation à Lancy", xaxis = list(showgrid = T), hovermode= FALSE,
        yaxis = list(showgrid = F, showlegend=F, showticklabels = FALSE, title= "", range= c(0,3)))
  }
  )
  
  output$prog_sensimap<- renderLeaflet({
    leaflet() %>% addTiles() %>% 
      setView(6.12, 46.183667, zoom=13) %>%
      addPopups(
        lat = 46.183667, lng = 6.115085,
        content1, 
        options = popupOptions(closeButton = TRUE)) %>%
      addMarkers(lat = 46.183667, lng = 6.115085)
  })


  #Boutons Infobox pour cliquer et attérir sur une autre page:
  output$richesse1 <- renderInfoBox({
    infoBox("Qualité de la biodiversité",
            a("cliquer ici", onclick = "openTab('presentation_quality')", target="_blank"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                             });
                             }
                             ")),
            icon = icon("leaf"), color = "blue"
            )
  })
  output$pression1 <- renderInfoBox({
    infoBox("Pressions",
            a("cliquer ici", onclick = "openTab('presentation_pression')", target="_blank"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                             });
                             }
                             ")),
            icon = icon("thumbs-down"), color = "red"
            )
    })
  output$benefit1 <- renderInfoBox({
    infoBox("Bénéfices",
            a("cliquer ici", onclick = "openTab('presentation_benefit')", target="_blank"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                             });
                             }
                             ")),
            icon = icon("check-circle"), color = "green"
            )
    })
  output$resultats1 <- renderInfoBox({
    infoBox("Mesures",
            a("cliquer ici", onclick = "openTab('presentation_resultats')", target="_blank"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                         });
                         }
                         ")),
        icon = icon("trophy"), color = "yellow"
        )
  })
  output$comparaison1 <- renderInfoBox({
    infoBox("Résumé de 5 indicateurs",
            a("cliquer ici", onclick = "openTab('comparaison')", target="_blank"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                             });
                             }
                             ")),
            icon = icon("compass"), color = "purple"
    )
  })
  output$sources1 <- renderInfoBox({
    infoBox("Sources des données",
            a("cliquer ici", onclick = "openTab('sources_data')", target="_blank"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                             });
                             }
                             ")),
            icon = icon("book"), color = "olive"
    )
  })
  
  #Bouton pour cliquer depuis les pages des catégories sur un indicateur:
  observe({
    if (input$ind_richesse1>0)
      updateTabsetPanel(session,"menu",selected = "ind_richesse")
  })
  observe({
    if (input$ind_div1>0)
      updateTabsetPanel(session,"menu",selected = "ind_diversite")
  })
  observe({
    if (input$ind_corr1>0)
      updateTabsetPanel(session,"menu",selected = "ind_trames")
  })
  observe({
    if (input$ind_listes1>0)
      updateTabsetPanel(session,"menu",selected = "ind_listerouge")
  })
  
  observe({
    if (input$ind_exo1>0)
      updateTabsetPanel(session,"menu",selected = "ind_envahissantes")
  })
  observe({
    if (input$ind_frag1>0)
      updateTabsetPanel(session,"menu",selected = "ind_fragmentation")
  })
  observe({
    if (input$ind_bruit1>0)
      updateTabsetPanel(session,"menu",selected = "ind_sonore")
  })
  observe({
    if (input$ind_lum1>0)
      updateTabsetPanel(session,"menu",selected = "ind_lumineuse")
  })
  observe({
    if (input$ind_agri1>0)
      updateTabsetPanel(session,"menu",selected = "ind_agricole")
  })
  observe({
    if (input$ind_imper1>0)
      updateTabsetPanel(session,"menu",selected = "ind_imper")
  })
  observe({
    if (input$ind_poll1>0)
      updateTabsetPanel(session,"menu",selected = "ind_pollinisation")
  })
  observe({
    if (input$ind_carbone1>0)
      updateTabsetPanel(session,"menu",selected = "ind_carbone")
  })
  observe({
    if (input$ind_espaces1>0)
      updateTabsetPanel(session,"menu",selected = "ind_protege")
  })
  observe({
    if (input$ind_SPB1>0)
      updateTabsetPanel(session,"menu",selected = "ind_compensation")
  })
  observe({
    if (input$ind_invest1>0)
      updateTabsetPanel(session,"menu",selected = "ind_investissement")
  })
  observe({
    if (input$ind_prog1>0)
      updateTabsetPanel(session,"menu",selected = "ind_programme")
  })
  ###Boutons suivants:
  observe({
    if (input$suivant1>0)
      updateTabsetPanel(session,"menu",selected = "ind_richesse")
  })
  observe({
    if (input$suivant2>0)
      updateTabsetPanel(session,"menu",selected = "ind_diversite")
  })
  observe({
    if (input$suivant3>0)
      updateTabsetPanel(session,"menu",selected = "ind_trames")
  })
  observe({
    if (input$suivant4>0)
      updateTabsetPanel(session,"menu",selected = "ind_listerouge")
  })
  observe({
    if (input$suivant5>0)
      updateTabsetPanel(session,"menu",selected = "presentation_pression")
  })
  observe({
    if (input$suivant6>0)
      updateTabsetPanel(session,"menu",selected = "ind_envahissantes")
  })
  observe({
    if (input$suivant7>0)
      updateTabsetPanel(session,"menu",selected = "ind_fragmentation")
  })
  observe({
    if (input$suivant8>0)
      updateTabsetPanel(session,"menu",selected = "ind_lumineuse")
  })
  observe({
    if (input$suivant9>0)
      updateTabsetPanel(session,"menu",selected = "ind_agricole")
  })
  observe({
    if (input$suivant10>0)
      updateTabsetPanel(session,"menu",selected = "ind_sonore")
  })
  observe({
    if (input$suivant11>0)
      updateTabsetPanel(session,"menu",selected = "ind_imper")
  })
  observe({
    if (input$suivant12>0)
      updateTabsetPanel(session,"menu",selected = "presentation_benefit")
  })
  observe({
    if (input$suivant13>0)
      updateTabsetPanel(session,"menu",selected = "ind_pollinisation")
  })
  observe({
    if (input$suivant14>0)
      updateTabsetPanel(session,"menu",selected = "ind_carbone")
  })
  observe({
    if (input$suivant15>0)
      updateTabsetPanel(session,"menu",selected = "presentation_resultats")
  })
  observe({
    if (input$suivant16>0)
      updateTabsetPanel(session,"menu",selected = "ind_protege")
  })
  observe({
    if (input$suivant17>0)
      updateTabsetPanel(session,"menu",selected = "ind_compensation")
  })
  observe({
    if (input$suivant18>0)
      updateTabsetPanel(session,"menu",selected = "ind_investissement")
  })
  observe({
    if (input$suivant19>0)
      updateTabsetPanel(session,"menu",selected = "ind_programme")
  })
  observe({
    if (input$suivant20>0)
      updateTabsetPanel(session,"menu",selected = "accueil")
  })

  ###Boutons précédents:
  observe({
    if (input$precedent1>0)
      updateTabsetPanel(session,"menu",selected = "accueil")
  })
  observe({
    if (input$precedent2>0)
      updateTabsetPanel(session,"menu",selected = "presentation_quality")
  })
  observe({
    if (input$precedent3>0)
      updateTabsetPanel(session,"menu",selected = "ind_richesse")
  })
  observe({
    if (input$precedent4>0)
      updateTabsetPanel(session,"menu",selected = "ind_diversite")
  })
  observe({
    if (input$precedent5>0)
      updateTabsetPanel(session,"menu",selected = "ind_trames")
  })
  observe({
    if (input$precedent6>0)
      updateTabsetPanel(session,"menu",selected = "ind_listerouge")
  })
  observe({
    if (input$precedent7>0)
      updateTabsetPanel(session,"menu",selected = "presentation_pression")
  })
  observe({
    if (input$precedent8>0)
      updateTabsetPanel(session,"menu",selected = "ind_envahissantes")
  })
  observe({
    if (input$precedent9>0)
      updateTabsetPanel(session,"menu",selected = "ind_fragmentation")
  })
  observe({
    if (input$precedent10>0)
      updateTabsetPanel(session,"menu",selected = "ind_lumineuse")
  })
  observe({
    if (input$precedent11>0)
      updateTabsetPanel(session,"menu",selected = "ind_agricole")
  })
  observe({
    if (input$precedent12>0)
      updateTabsetPanel(session,"menu",selected = "ind_sonore")
  })
  observe({
    if (input$precedent13>0)
      updateTabsetPanel(session,"menu",selected = "ind_imper")
  })
  observe({
    if (input$precedent14>0)
      updateTabsetPanel(session,"menu",selected = "presentation_benefit")
  })
  observe({
    if (input$precedent15>0)
      updateTabsetPanel(session,"menu",selected = "ind_pollinisation")
  })
  observe({
    if (input$precedent16>0)
      updateTabsetPanel(session,"menu",selected = "ind_carbone")
  })
  observe({
    if (input$precedent17>0)
      updateTabsetPanel(session,"menu",selected = "presentation_resultats")
  })
  observe({
    if (input$precedent18>0)
      updateTabsetPanel(session,"menu",selected = "ind_protege")
  })
  observe({
    if (input$precedent19>0)
      updateTabsetPanel(session,"menu",selected = "ind_compensation")
  })
  observe({
    if (input$precedent20>0)
      updateTabsetPanel(session,"menu",selected = "ind_investissement")
  })
}
