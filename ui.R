## ui.R ##
library(shiny)
library(shinydashboard)
library(plotly)
library(leaflet)
library(markdown)

convertMenuItem <- function(mi,tabName) { #fonction utilisée pour avoir la page nommée accueil directement en page d'accueil et pas les sous-classes
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  if(length(mi$attribs$class)>0 && mi$attribs$class=="treeview"){
    mi$attribs$class=NULL
  }
  mi
}

ui<- dashboardPage(
              skin = "green",
              dashboardHeader(
                title = "Zoom sur la biodiversité de Lancy", #ajouter un titre
                titleWidth = 400 #agrandir la fenêtre du titre
                ),
              dashboardSidebar(
                width = 325,
                sidebarMenu(id="menu",  
                            convertMenuItem(menuItem("Accueil", tabName = "accueil", icon = icon("home"), selected=T, #permettre que la page s'ouvre sur la page d'accueil
                                     menuSubItem(text= "Résumé de 5 indicateurs", tabName= "comparaison", icon= icon("compass")),
                                     menuSubItem(text = "Sources des données", tabName = "sources_data", icon = icon("book"))), "accueil"),
                            menuItem("Qualité de la biodiversité", tabName = "quality", icon = icon("leaf"), 
                                     menuSubItem(text = "Présentation", tabName = "presentation_quality"),
                                     menuSubItem(text ="Richesse des espèces",tabName = "ind_richesse"),
                                     menuSubItem(text = "Diversité des milieux", tabName = "ind_diversite"),
                                     menuSubItem(text = "Corridors de passage", tabName = "ind_trames"),
                                     menuSubItem(text = "Espèces en listes rouges", tabName = "ind_listerouge")),
                            #tous les icônes disponibles se trouvent sur internet
                            menuItem("Pressions", tabName = "pression", icon = icon("thumbs-down"),
                                     menuSubItem(text = "Présentation", tabName = "presentation_pression"),
                                     menuSubItem(text = "Espèces exotiques envahissantes",tabName = "ind_envahissantes"),
                                     menuSubItem(text = "Fragmentation des milieux", tabName = "ind_fragmentation"),
                                     menuSubItem(text = "Pollution lumineuse", tabName = "ind_lumineuse"),
                                     menuSubItem(text = "Pollution agricole", tabName = "ind_agricole"),
                                     menuSubItem(text = "Pollution sonore",tabName = "ind_sonore"),
                                     menuSubItem(text = "Imperméabilisation des sols", tabName = "ind_imper")),
                            menuItem("Bénéfices", tabName = "benefit", icon = icon("check-circle"),
                                     menuSubItem(text = "Présentation", tabName = "presentation_benefit"),
                                     menuSubItem(text = "Pollinisation",tabName = "ind_pollinisation"),
                                     menuSubItem(text= "Carbone", tabName = "ind_carbone")),
                            menuItem("Résultats", tabName = "resultats", icon = icon("trophy"),
                                     menuSubItem(text = "Présentation", tabName = "presentation_resultats"),
                                     menuSubItem(text = "Espaces protégés",tabName = "ind_protege"),
                                     menuSubItem(text = "Surfaces de promotion de la biodiversité", tabName = "ind_compensation"),
                                     menuSubItem(text = "Investissements pour la biodiversité", tabName = "ind_investissement"),
                                     menuSubItem(text = "Programmes de sensibilisation", tabName = "ind_programme"))
                )
              ),
              dashboardBody(
                tags$head(
                tags$link(rel = "stylesheet", type = "text/css", href = "style_dashboard.css") #intégrer la page CSS pour la page body
                ),
                tabItems(
                  ###Accueil###
                  tabItem(tabName = "accueil", h1("Zoom sur la biodiversité de Lancy", tags$img(
                    src="Lancy-drapeau.png", height= 80, width=70)),
                    h3("Qu'est-ce que la biodiversité? Combien y a-t-il d'espèces à Lancy? Qu'est-ce que la disparition des espèces
                        et qu'est-ce qui les fait disparaître?... Toutes ces questions concernent la biodiversité, mais il est souvent difficile
                        d'y trouver des réponses simples et claires. C'est pourquoi, de manière générale, il semble que la population manque
                        d'informations lui permettant de comprendre et de connaître ce qu'est la biodiversité et son évolution. Dans cette optique,
                        ce site, réalisé dans le cadre d’un travail de master à l’Université de Genève, est un exercice offrant 
                        la possibilité aux lancéans et aux autorités de se renseigner sur l'état de la biodiversité dans 
                        la commune et de comprendre l'enjeu derrière le problème de l'appauvrissement de la biodiveristé. Il s'agit donc à la fois d'un outil
                        de sensibilisation sur cette thématique et en même temps un instrument d'aide à la décision afin que les autorités aient
                       une information utile et à jour pour qu'ils prennent en considération, dans leurs décisions, la biodiversité et ses enjeux."),
                    br(), 
                    fluidRow(box(width= 6, title= "La biodiversité: Qu'est-ce que c'est?", status= "warning", solidHeader= TRUE,
                                 collapsible = T, 
                                 h3('La biodiversité peut être définie comme "la base de vie sur terre"', tags$a(href="https://www.bafu.admin.ch/dam/bafu/fr/dokumente/biodiversitaet/uz-umwelt-zustand/biodiversitaet-schweiz-zustand-entwicklung.pdf.download.pdf/UZ-1630-F_2017-06-20.pdf. ", 
                                                                                                                 "(OFEV, 2017)."),
                                    'Elle prend en compte "la diversité au sein des espèces et entre espèces ainsi que celle des écosystèmes"',
                                    tags$a(href="https://www.cbd.int/doc/legal/cbd-fr.pdf", 
                                           "(ONU, 1992)."),
                                    "La biodiversité produit également des services écosystèmiques, essentiels pour nos sociétés actuelles,
                                    sans eux nous ne pourrions vivre comme nous le faisons aujourd'hui. Nous sommes totalement 
                                    dépendants de ces services. Il s'agit par exemple des denrées alimentaires que nous retirons de la biodiversité,
                                    de sa capacité à réguler le climat ou encore de l'eau potable qu'elle produit.", br(),
                                    "La vidéo ci-dessous permet de résumer et d'illustrer ce qu'est la biodiversité, de
                                    façon ludique.", tags$a(href= "https://www.youtube.com/watch?v=9oxr0yhC7cE",
                                                            "(Source Vidéo: 1 jour, 1 question)"), br(), br(),
                                    div(style="text-align:center",HTML('<iframe width="400" height="315" 
                                                                       src="https://www.youtube.com/embed/9oxr0yhC7cE" 
                                                                       frameborder="0" allow="autoplay; encrypted-media" 
                                                                       allowfullscreen></iframe>'))
                                    )),
                             box(width= 6, title= div(HTML(paste("Une urgence aujourd'hui:", "l'appauvrissement de la biodiversité",
                                                             sep= "<br/>")), align= "center"), #insère une fonction HTML pour permettre de mettre à la ligne
                                 status= "danger", solidHeader= TRUE,
                                 collapsible = T, 
                                 h3(
                                   "En juillet 2017, l'Office fédéral de l'Environnement (OFEV) a sorti un rapport sur 
                                   l'état de la biodiversité en 2016. Ce dernier est alarmant et évoque le manque de mesures 
                                   réellement efficaces", tags$a(href="https://www.bafu.admin.ch/dam/bafu/fr/dokumente/biodiversitaet/uz-umwelt-zustand/biodiversitaet-schweiz-zustand-entwicklung.pdf.download.pdf/UZ-1630-F_2017-06-20.pdf. ", 
                                                                 "(OFEV, 2017)."),
                                   "Depuis une vingtaine d'années beaucoup de mesures ont été prises
                                   afin de répondre à ce problème. Mais malgré ces efforts, l'appauvrissement de la biodiversité 
                                   reste préoccupant. De plus en plus, le monde scientifique tire la sonnette
                                   d'alarme sur l'importance d'agir avant qu'il ne soit trop tard. La vidéo
                                    ci-dessous permet de comprendre les menaces pesant sur la biodiversité
                                  et l'importance de la préserver", 
                                   tags$a(href="https://www.youtube.com/watch?v=GuS9EU4iRjw", "(Source Vidéo: UNESCO)."), br(),
                                   br(),
                                   div(style="text-align:center",HTML('<iframe width="400" height="315" 
                                                                      src="https://www.youtube.com/embed/GuS9EU4iRjw" 
                                                                      frameborder="0" allow="autoplay; encrypted-media" 
                                                                      allowfullscreen></iframe>')),
                                  br()
                                 )), align= "center"),
                    fluidRow(box(width= 12, title= "Comment évaluer la biodiversité?", 
                                 status= "primary", solidHeader = TRUE, 
                                 h3("En attendant, il est souvent 
                                  difficile pour la population de savoir où en est sa biodiversité. La biodiversité est un concept 
                                  complexe, évoquant de multiples éléments.
                                    C'est pourquoi il a été choisi de développer différents indicateurs, 
                                    afin de synthétiser au mieux l'information existante et de pouvoir sortir des
                                    tendances sur la situation et l'évolution de la biodiversité.
                                    De plus, ces indicateurs ont été répartis en fonction de 4 catégories, permettant ainsi de comprendre
                                    les relations entre chaque indicateur:",
                                    div(
                                    infoBoxOutput("richesse1", width = 6),
                                    infoBoxOutput("pression1", width = 6),
                                 infoBoxOutput("benefit1", width = 6),
                                 infoBoxOutput("resultats1", width = 6), style= 'padding:10px'))
                                 ), align= "center"),
                    fluidRow(box(width= 12, title= "Pour aller plus vite et plus loin...", status= "success", solidHeader= TRUE,
                                 collapsible = T, collapsed = T,
                                 h3("Les deux pages, Comparaison de 5 indicateurs et Sources de données, permettent, pour la 
                                    première de faire un résumé de 5 indicateurs. Elle est utile si l'on veut un coup d'oeil sur la situation
                                    de la commune de façon synthétisée. La seconde page résume les sources des données permettant d'aller
                                    plus loin et de comprendre d'où proviennent chacune des données utilisées."),
                                 infoBoxOutput("comparaison1", width = 6),
                                 infoBoxOutput("sources1", width = 6)
                                 ))
                    ),
                  tabItem(tabName = "comparaison", h2("Comparaison et résumé des résultats de 5 indicateurs"),
                          fluidRow(box(width= 12, title= "Graphique résumant plusieurs indicateurs", status= "success", solidHeader= TRUE,
                                       collapsible = TRUE,
                                       plotlyOutput("qualite1plotly", width = "600px", height = "800px")), 
                                   br(), box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                              h3("Ce gaphique permet de comparer les résultats entre Lancy et le canton. 
                                                   Mais également de voir la proportion de chaque indicateur entre eux et de pouvoir,
                                                    dans la mesure du possible, les comparer. Grâce à ce graphique, 
                                                    nous pouvons constater que la commune de Lancy a toujours une situation 
                                                    « moins bonne » que celle du canton (même si tous les résultats sont 
                                                    en valeurs relatives, afin de ne pas biaiser les mesures avec le canton). 
                                                    Cependant, au niveau des SPB la commune est proche de la situation au niveau cantonal. ")),
                                   box(width= 12, title= "Besoin de plus d'informations?", status= "danger", solidHeader= TRUE,
                                       h3("Ce graphique résume grandement les résultats de 5 indicateurs. Pour avoir plus de détails sur ces indicateurs,
                                          ou sur les autres indicateurs existants, il suffit de continuer la visite du reste du site pour être pleinement informé.")), 
                                   align= "center")),
                  tabItem(tabName = "sources_data", h2("Présentation des sources de données"),
                          fluidRow(box(width= 12, title= "", status= "danger", solidHeader= TRUE,
                                       h3("Différents canaux de données existent en Suisse, et ce, à 
                                          différents niveaux (national, cantonal, communal), il a donc fallu 
                                          se plonger dans les sites et bases de données correspondantes. 
                                          Les données récupérées proviennent des sources suivantes: ",
                                          div(style= 'padding:15px',
                                              tags$li(tags$a(href="https://www.infospecies.ch/fr/atlas-en-ligne.html", "InfoSpecies")),
                                              tags$li(tags$a(href="https://www.infoflora.ch/fr/", "Infoflora")),  
                                              tags$li(tags$a(href="https://www.vogelwarte.ch/fr/oiseaux/les-oiseaux-de-suisse/", 
                                                             "Station ornithologique suisse")),
                                              tags$li(tags$a(href="https://lepus.unine.ch/tab/", "CSCF-Karch")),
                                              tags$li(tags$a(href="https://ge.ch/sitg/", "Le Système
                                                             d'Information du Territoire à Genève (SITG)")),
                                              tags$li(tags$a(href="http://www.ge21.ch/", "GE-21")),
                                              tags$li("La commune de Lancy", tags$a(href="https://www.lancy.ch/", "(Site Web)")),
                                              tags$li("Des anciens travaux de Master du MUSE", tags$a(href="http://www.unige.ch/muse/", 
                                                                                                      "(Site Web)"))
                                              ))), 
                                   align= "center")),
                  ###Qualité de la biodiversité###
                  tabItem(tabName = "presentation_quality", 
                          fluidRow(box(title= h2("Catégorie: Qualité de la biodiversité"), status= "danger",  
                                      h3("Cette première catégorie permet de renseigner sur l'état de la biodiversité.
                                      En effet, il semble souvent difficile de se rendre compte de la situation des espèces
                                      et des écosystèmes. C'est pourquoi cette partie tente, à travers quatre indicateurs, de donner 
                                      un aperçu de la qualité de la biodiversité à l'échelle communale, en la comparant avec des
                                      échelles plus grande ou avec les résultats des autres communes du canton, afin d'avoir une échelle de comparaison.",
                                      br(), "Les quatre indicateurs choisis sont les suivants:", br(), br(),
                                      div( #l'utilisation de div() permet de par exemple mettre un style à une seule sélection
                                      actionButton(inputId= "ind_richesse1", "La richesse des espèces", style="background-color:#afdfed"),
                                      actionButton(inputId= "ind_div1", "La diversité des milieux", style="background-color:#afdfed"),
                                      actionButton(inputId= "ind_corr1", "Les corridors de passage", style="background-color:#afdfed"),
                                      actionButton(inputId= "ind_listes1", "Les espèces sur listes rouges", style="background-color:#afdfed"), style="text-align:center"))
                                      , width= 12, align= "center")),
                          fluidRow(actionButton(inputId = "precedent1", label = "Page d'accueil"),
                                   actionButton(inputId = "suivant1", label = "Indicateur suivant"), align= "center")), #ajouter des boutons indic suivant
                  tabItem(tabName = "ind_richesse", h2("Indicateur: Richesse des espèces présentes"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE, #ajoute une box avec couleur et options
                                       h3("Dans le but de pouvoir renseigner sur la qualité de la biodiversité, une estimation des espèces
                                          vivantes sur le territoire de la commune a été faite. Elle permet ainsi de savoir combien d'espèces 
                                          différentes sont établies à Lancy. Les données ont été récupérées de la Direction générale de l’agriculture et de la nature
                                          (DGAN), en provenance de différents centres nationaux, et d'Infoflora.
                                          Il a ainsi été possible de calculer la richesse d'espèces connues jusqu'en 2018 sur la commune. Ci-dessous se trouvent les 
                                          liens aux différents centres, sources des données récupérées. Quatre classes d'espèces faunistiques et trois groupes de flore
                                          ont été sélectionnés, afin d'estimer la richesse en espèces. D'autres groupes et classes pourraient être ajoutés dans le futur.
                                          Toutefois cette première représentation permet de donner une estimation de ce qui est présent à Lancy."),
                                       h3("Les listes d'espèces sont disponibles sur les sites suivants:",
                                          div(style= 'padding:15px',
                                          tags$li(tags$a(href="https://www.infospecies.ch/fr/atlas-en-ligne.html", "InfoSpecies")),
                                          tags$li(tags$a(href="https://www.infoflora.ch/fr/", "Infoflora")),  
                                          tags$li(tags$a(href="https://www.vogelwarte.ch/fr/oiseaux/les-oiseaux-de-suisse/", 
                                                         "Station ornithologique suisse")),
                                          tags$li(tags$a(href="https://lepus.unine.ch/tab/", "CSCF-Karch"))),
                                          br(), "Sur ces sites, est disponible un certain nombre d'informations, tel que
                                          les listes des espèces présentes sur la commune, des fiches explicatives par espèce, etc."))),
                          fluidRow(box(title= "Résultats: Espèces de faune", status= "success", solidHeader= TRUE,
                                       plotlyOutput("plotEsp")),
                                              box(title = "Résultats Espèces de flore", status= "success", solidHeader= TRUE,
                                                  plotlyOutput("plotFlore"))),
                          fluidRow(box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("Les deux graphiques permettent de comparer la situation sur la commune avec celle sur le canton. Les
                                          résultats sont en valeurs absolues, c'est pourquoi le canton a toujours des résultats plus élevés que la
                                          commune. Cependant, il est à noter que les oiseaux sont la classe la plus représentée au niveau communal. 
                                          Au niveau cantonal, c’est le groupe des insectes qui est le plus représenté. 
                                          Pour la flore, les angiospermes sont les plus représentés à la fois pour la commune et le canton.", br(),
                                          "Il est possible d'interroger les graphiques en passant au dessus d'eux afin d'avoir les résultats pour chaque
                                          groupe, ou d'utiliser les outils en haut de chacun d'eux (zoom, agrandissement, etc.).")
                                       )),
                          helpText("Données en provenance de la DGAN et de Infoflora"),
                          fluidRow(actionButton(inputId = "precedent2", label = "Présentation précédente"),
                                   actionButton(inputId = "suivant2", label = "Indicateur suivant")), align= "center"),
                  tabItem(tabName = "ind_diversite", 
                          h2("Indicateur: Diversité des milieux naturels"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("Les espèces vivantes sur le territoire sont dépendantes des milieux présents, car certaines
                                          d'entre-elles sont spécialisées dans certains milieux. C'est pourquoi, la 
                                          disparition de certains milieux entraîne une perte potentielle d'espèces dépendantes de
                                          ces milieux. Il est donc important de pouvoir avoir une information sur les milieux présents.",
                                          br(),
                                          "La diversité des milieux permet d'estimer en un indice à la fois la richesse des milieux présents
                                          et prend également en considération la fréquence de chaque milieu. Les résultats de cet indicateur
                                          (calculé à une échelle de 50m) varie entre
                                          0 (pas de diversité) et Log du nombre de milieux présents (diversité la plus importante). Nous partons donc de 
                                          l'hypothèse que plus un espace est diversifié, plus il sera favorable à la biodiversité. Les milieux
                                          urbanisés (routes, bâtiments,etc.) ne sont pas compris dans ce calcul, afin de pouvoir avoir une
                                          représentation des milieux les plus bénéfiques à la biodiversité."))),
                          fluidRow(box(width= 6, title= "Boxplot", status= "success", solidHeader= TRUE, 
                                       plotlyOutput("plotDiv", height= "400px")),
                                   box(width= 6, title= "Explication du Boxplot", status= "warning", solidHeader = TRUE,
                                       h3("Cette représentation permet de comparer la distribution des résultats de la commune 
                                          et celle du canton. Elle révèle ainsi que les résultats pour Lancy semblent 
                                          être distribués vers des indices un peu plus hauts que ceux du canton 
                                          (la médiane est légèrement plus haute ainsi que la distribution autour 
                                          de la médiane est resserrée et les 25% des résultats les plus bas ont des indices plus 
                                          élevés que le canton). Il semblerait donc que Lancy ait une tendance à une 
                                          diversité en milieux plus élevée par rapport à la distribution du canton.")
                                   )),
                          fluidRow(
                            box(width= 8, title = "Diagramme en barre par quartier", status= "success", solidHeader= TRUE,
                                plotlyOutput("plotDivLancy", height= "700px")),
                            box(width= 4, title= "Explication du diagramme", status= "warning", solidHeader = TRUE,
                                       h3("Ce diagramme en barre permet de comparer les moyennes par quartier sur 
                                          la commune de Lancy. Au vu de ses résultats, 
                                          nous constatons que les quartiers proches de l’Aire sont les plus diversifiés.")
                                       )),
                          fluidRow(leafletOutput("div_milieuGIREC", width = "900px"), br()),
                          fluidRow(
                            box(width= 12, title= "Explication de la carte", status= "warning", solidHeader = TRUE,
                                collapsible = TRUE,
                                h3("La représentation cartographique permet de confirmer et de visualiser ce qui a été énoncé précédemment à propos
                                   des résultats par quartier. De plus, la carte recouvrant tout le canton de Genève permet de constater
                                   des résultats très hétérogènes partout sur la surface cantonale. Il est à noter toutefois que le centre de 
                                   la ville de Genève a les résultats les plus bas.", br(),
                                   "Il est possible d'interroger la carte, en zoomant, en s'y déplaçant et en sélectionnant la (ou les)
                                   cartes à visualiser, en fonction des options intégrées sur la représentation cartographique.")
                            )),
                          helpText("Données: Ge21, Projet RPT - Indicateurs Services Ecosystémiques"),
                          fluidRow(actionButton(inputId = "precedent3", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant3", label = "Indicateur suivant")), align= "center"),
                  tabItem(tabName = "ind_trames",h2("Indicateur: Corridors de passage pour les espèces"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("De plus en plus, les espaces de passages pour les espèces de faune deviennent un sujet 
                                          alarmant, et ce à toutes les échelles. La fragmentation du territoire, dûe à l'urbanisation
                                          et au développement des zones de transports, est de plus en plus
                                          problématique pour le déplacement des espèces. Il y a un réel besoin de 
                                          créer des lieux de passage, des couloirs pour ces animaux. C'est pourquoi, au niveau national 
                                          et au niveau cantonal, de plus en plus de moyens sont mis en place pour développer des zones de passage
                                          pour les espèces de faune. De plus, dans le contexte genevois,
                                          avec le développement du Grand Genève, 
                                          cette thématique est d’autant plus d’actualité, car les espèces faunistiques n’ont 
                                          pas de frontière, il faut donc coordonner l’espace des deux côtés des pays. C'est d'ailleurs
                                          l'un des objectifs de la Stratégie Biodiversité 2030 du canton de Genève, 
                                          acceptée il y a quelques mois, d’aménager les corridors de passages à faune. 
                                          De ce fait, le suivi de ces corridors semble être un indicateur particulièrement essentiel 
                                          afin d’évaluer l’état de la biodiversité au niveau communal. Trois types de corridors ont été
                                          sélectionnés afin d'évaluer les zones de passage à faune:", 
                                          div(style= 'padding:15px',
                                          tags$li("Les corridors jaunes (ou agricoles): les prairies, vergers, cultures extensives, etc.", tags$a(href="https://ge.ch/sitg/fiche/9438", "(Source SITG)")),
                                          tags$li("Les corridors bleus (ou aquatiques): les cours d'eau, zones humides et berges.", tags$a(href="https://ge.ch/sitg/fiche/9440", "(Source SITG)")),
                                          tags$li("Les corridors verts (ou forestiers): les fôrets, bosquets, bois, etc.", tags$a(href="https://ge.ch/sitg/fiche/0824", "(Source SITG)"))),
                                          "La vidéo ci-dessous permet de résumer l'explication et l'importance des corridors biologiques",
                                          tags$a(href="https://www.youtube.com/watch?v=k8c9By29cKo", "(Source Vidéo: CEN Savoie)."), br(), br(),
                                          div(style="text-align:center",HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/k8c9By29cKo" 
                                                                             frameborder="0" allow="autoplay; encrypted-media" 
                                                                             allowfullscreen></iframe>')) #pour ajouter une vidéo soit ajouter avec fonction HTML, soit avec fonction tag$iframe
                                          ))),
                          fluidRow(box(width= 12, title= "Diagramme par commune",
                                       status= "success", solidHeader= TRUE, collapsible = TRUE,
                                       plotlyOutput("plotCorr", width = "750px", height = "1500px"))),
                          fluidRow(valueBoxOutput("Corr_Agri_Lancy_pourcentage", width = 4),
                                   valueBoxOutput("Corr_Aqua_Lancy_pourcentage", width = 4),
                                   valueBoxOutput("Corr_Foret_Lancy_pourcentage", width = 4)),
                          fluidRow(box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("Le diagramme en barres pour toutes les communes de Genève a été créé 
                                          afin de pouvoir comparer dans quelles communes il y a le plus de corridors 
                                          biologiques, en surface relative. Cela permet de constater que Lancy a une très petite
                                          part de son territoire identifiée comme passage à faune.
                                          Ce type d’information ne prend de sens, 
                                          que s’il y a un suivi dans le temps afin de voir l’évolution de ces corridors 
                                          dans chaque commune, et pouvoir estimer les modifications, les pertes ou les 
                                          gains de chaque corridor.", br(), "Ci-dessous la représentation cartographique permet
                                          de visualiser où se trouve chaque corridor sur tout 
                                          le territoire du Grand Genève. Cela permet de montrer la nécessité de travailler 
                                          au-delà des frontières. De plus, il est à constater que même si la commune de Lancy 
                                          ne comprend qu’une infime part de corridors biologiques, nous retrouvons, comme pour
                                          l'indicateur de diversité des milieux, de nouveau 
                                          la zone autour de l’Aire comme faisant partie des corridors de forêts. L’Aire et ses 
                                          environs semblent donc être des zones d’importance en 
                                          termes de qualité de la biodiversité sur le périmètre de la commune.")
                                       )),
                          fluidRow(leafletOutput("corr_mapGE", width = "900px")),
                          #les statuts sont les couleurs  au dessus des titres 
                          #solidheader= permet de colorer toute la bande du titre
                          #collapsible = TRUE ==> permet de faire fenètre ouvrante/fermante du graphique/image,...
                          #background = "yellow" ==> le fond du graphique devient de la couleur qu'on lui donnne
                          #height= la grandeur de la boîte, on configure manuellement comme ça ont toutes la même grandeur
                          fluidRow(),
                          helpText("Données en provenance du SITG"),
                          fluidRow(actionButton(inputId = "precedent4", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant4", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  tabItem(tabName = "ind_listerouge", h2("Indicateur: Espèces en listes rouges dans la commune"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("Le dernier indicateur choisi pour estimer l'état de la biodiversité, est le poids de menace pesant
                                          sur chaque espèce, car une espèce peut être présente, mais être grandement menacée d’extinction. 
                                          C’est pourquoi l’indicateur du nombre d’espèces sur listes rouges a été sélectionné. L'un des buts 
                                          au niveau suisse est de se battre contre la disparition des espèces et de les préserver au maximum.
                                          Pour cela, elle se base sur les listes rouges de l'Union International pour la Conservation de 
                                          la Nature (UICN). Pour qu’une espèce soit mise dans une des catégories de listes rouges, 
                                          il y a plusieurs critères qui sont étudiés et l'évaluation de la place de chaque espèce est régulièrement
                                          mise à jour, afin d'évaluer au mieux l'état des menaces pesant sur chaque espèce. Ci-dessous une image permet de
                                          visualiser les différentes catégories des listes rouges.", br(),
                                          tags$img(
                                            src="red_list1.png", height= 300, width=400, style="display: block; margin-left: auto; margin-right: auto;"), br(), 
                                          div(style="text-align:center", #permet de centrer qu'une partie du texte
                                              "Source:", 
                                          tags$a(href="http://cmsdocs.s3.amazonaws.com/keydocuments/Categories_and_Criteria_fr_web%2Bcover%2Bbckcover.pdf", 
                                                 "UICN, 2000", align="center"))))),
                          fluidRow(box(width=6, title= "Résultats pour le Canton",
                                       status= "success", solidHeader= TRUE, plotlyOutput("plotRedList1", height= "600px")), 
                                   box(width=6, title= "Résultats pour Lancy",
                                       status= "success", solidHeader= TRUE, plotlyOutput("plotRedList2", height= "600px"))),
                          fluidRow(box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("Les résultats de cet indicateur permettent d'estimer en fonction de chaque groupe 
                                          et classe de faune et de flore, la part relative de chaque catégorie de
                                          listes rouges. Ainsi il peut être conclu qu’il y a plus d’amphibiens et reptiles 
                                          en danger critique par rapport au total, à Lancy, qu’il n’y en a sur le canton. 
                                          Il est également à noter qu’il n’y a pas d’espèces éteintes sur la commune et 
                                          ce pour toutes les catégories étudiées. Cependant, il y a au total environ 18% 
                                          des espèces présentes à Lancy qui ont statut vulnérable ou plus, 
                                          contre environ 25% pour le canton.
                                          ")
                                       )),
                          helpText("Données en provenance de la DGAN et de Infoflora"),
                          fluidRow(actionButton(inputId = "precedent5", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant5", label = "Indicateur suivant")),
                          align= "center"),
                  ### Pression###
                  tabItem(tabName = "presentation_pression",
                          fluidRow(box(title= h2("Catégorie: Pressions sur la biodiversité"), status= "danger",  
                                       h3("Cette seconde catégorie permet de renseigner sur les menaces qui pèsent sur la biodiversité.
                                          En effet, de plus en plus de pressions déstabilisent les espèces et écosystèmes, et 
                                          peuvent à termes affaiblir la biodiversité. Il semble donc pertinent de pouvoir 
                                          visualiser ces menaces et de percevoir les endroits les plus sensibles et où il faudrait
                                          prendre des mesures. Le but est également de faire des comparaisons avec les indicateurs
                                          de la catégorie précédente, mais aussi, avec les suivantes, afin de pouvoir comprendre comment 
                                          tout fonctionne. Il pourrait ainsi être intéressant de voir les lieux où il y a le
                                          plus de pressions en fonction de la situation de la biodversité sur la commune et de comprendre
                                          les relations entre ces deux catégories.",
                                          br(), "Six indicateurs ont ainsi été choisis:", br(), br(),
                                          div( #l'utilisation de div() permet de par exemple mettre un style à une seule sélection
                                            actionButton(inputId= "ind_exo1", "Espèces exotiques envahissantes", style="background-color:#edafaf"),
                                            actionButton(inputId= "ind_frag1", "Fragmentation des milieux", style="background-color:#edafaf"),
                                            actionButton(inputId= "ind_lum1", "Pollution lumineuse", style="background-color:#edafaf"), br(),br(),
                                            actionButton(inputId= "ind_agri1", "Pollution diffuse agricole", style="background-color:#edafaf"),
                                            actionButton(inputId= "ind_bruit1", "Pollution sonore", style="background-color:#edafaf"),
                                            actionButton(inputId= "ind_imper1", "Imperméabilisation des sols", style="background-color:#edafaf"),
                                            style="text-align:center"))
                                       , width= 12, align= "center")),
                          fluidRow(actionButton(inputId = "precedent6", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant6", label = "Indicateur suivant")), align= "center"
                  ),
                  tabItem(tabName = "ind_envahissantes",
                          h2("Indicateur: Espèces exotiques envahissantes"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("Les espèces exotiques envahissantes sont un enjeu majeur de nos sociétés, car du fait de la mondialisation, les 
                                          espèces se font, elles aussi, transporter et cela amène à rendre la biodiversité de plus en plus
                                          semblable partout. Les espèces exotiques envahissantes sont définies comme des «plantes exotiques introduites 
                                          par les activités humaines après 1500 de manière intentionnelle ou non et qui se sont établies à l'état sauvage.
                                          [...] qui se répandent fortement et rapidement en entraînant des dommages» (Infoflora).", br(), 
                                          "Au  niveau des végétaux,
                                          deux listes existent, permettant ainsi un contrôle sur ces espèces. Ces listes sont aussi un outil d’aide à la 
                                          décision afin de savoir comment prévenir et lutter efficacement en fonction de chaque espèce. La Black List répertorie
                                          les plantes exotiques envahissantes «possédant, selon les connaissances actuelles, un fort potentiel 
                                          de propagation en Suisse et causant des dommages importants et prouvés au niveau de la diversité biologique, 
                                          de la santé et/ou de l'économie. La présence et l'expansion de ces espèces doivent être empêchées» et la
                                          Watch List renseigne sur les plantes exotiques envahissantes qui ont «selon les connaissances actuelles, 
                                          un potentiel de propagation modéré à fort en Suisse et causant des dommages modérés ou forts au niveau 
                                          de la diversité biologique, de la santé et/ou de l'économie. La présence et l'expansion de ces espèces 
                                          doivent être surveillées, et des connaissances supplémentaires sur ces espèces doivent être réunies» (Infoflora).
                                          Ces listes, disponibles actuellement que pour les végétaux, sont une indication des menaces pesant sur la biodiversité,
                                          et c'est pourquoi, ces espèces doivent être suivies.", 
                                          tags$a(href="https://www.infoflora.ch/fr/neophytes/listes-et-fiches.html", 
                                                 "(Source Infoflora)") ))),
                          fluidRow(column(width= 2), column(width=8, box(title= "Résultats", width= NULL, 
                                       status= "success", solidHeader= TRUE, align= "center", plotlyOutput("EspExoPlot", 
                                                                                          height= "400px", width= "500px"))),
                                   column(width= 2)),
                          fluidRow(box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("Le graphique ci-dessus présente donc les résultats permettant de dénombrer le nombre
                                          de plantes exotiques envahissantes pour la commune de Lancy, en fonction des deux listes
                                          présentées précédemment. Seules les données au niveau national ont pu être récupérées 
                                          à titre de comparaison avec les résultats de la commune. De ce fait, les résultats ne 
                                          sont pas très convaincants, il faudrait une échelle de comparaison
                                          plus fine, comme par exemple les résultats par commune du canton de Genève, pour faire une analyse
                                          plus pertinante.
                                          Toutefois, il peut être conclu qu’en 
                                          comparaison avec les observations suisses, Lancy a un peu plus d’un tier des espèces 
                                          exotiques envahissantes de flore connue au niveau national.")
                          )),
                          helpText("Données en provenance de la DGAN et de Infoflora"),
                          fluidRow(actionButton(inputId = "precedent7", label = "Présentation précédente"),
                                   actionButton(inputId = "suivant7", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  tabItem(tabName = "ind_fragmentation",
                          h2("Indicateur: Fragmentation des milieux"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("La fragmentation du territoire (ou morcellement du territoire) renseigne sur le 
                                          découpage du territoire induit par les routes, les bâtiments, chemins de fer, etc.
                                          Ces éléments vont créer des barrières difficilement franchissables pour les espèces
                                          de faune. En effet, cela va impacter sur la possibilité de se déplacer, de migrer,
                                          pour se nourrir et également pour se reproduire. Il est donc primordiale de savoir comment
                                          et où le territoire est découpé, afin d'aménager, protéger et restorer des zones de passages
                                          et d'habitat pour les espèces de faune. Cet indicateur est en lien avec l'indicateur
                                          de corridors de passage, puisque si l'on veut aménager en conséquence de la fragmentation,
                                          il faut créer des lieux de passage à faune permettant de reconnecter des espaces séparés 
                                          à cause de ce morcellement du territoire.", br(), "L'indicateur a été ici calculé sous forme d'indice
                                          (à une échelle de 100m).
                                          Les valeurs proches de zéro indique une fragmentation très élevée. On peut interpréter cela
                                          comme le fait que, plus la fragmentation est élevée, moins deux individus répartis au hasard sur un territoire
                                          donné arriveront à se rejoindre."))),
                          fluidRow(box(width= 6, title= "Boxplot", status= "success", solidHeader= TRUE, 
                                          plotlyOutput("boxplotFrag", height = "500px")),
                                   box(width= 6, title= "Explication du Boxplot", status= "warning", solidHeader = TRUE,
                                       h3("La distribution des résultats de la commune en comparaison avec celle du canton, laisse
                                          penser que Lancy est plus fragmenté que le canton. La distribution des valeurs de la commune 
                                          – en particulier la distribution de la médiane et de l’intervalle interquartile, 
                                          resserré autour de la médiane– est plus proche des valeurs de 0 que les résultats 
                                          pour le canton, indiquant une fragmentation plus importante. Il y aurait donc moins de zones 
                                          permettant les passages pour les espèces de faune sur la commune que sur le canton dans son ensemble.")
                                   )),
                          fluidRow(box(width= 8, title = "Diagramme en barre par quartier", status= "success", solidHeader= TRUE,
                                       plotlyOutput("plotFragGIREC", height = "900px")),
                                   box(width= 4, title= "Explication du diagramme", status= "warning", solidHeader = TRUE,
                                       h3("Cet indicateur a également été représenté à l’échelle des quartiers : 
                                          ceux-ci montrent que tous les quartiers sont passablement fragmentés – 
                                          au vu des moyennes par quartier ne dépassant pas 1,5. Cependant, les zones proches du Rhône 
                                          semblent être les moins fragmentées de la commune. Toutefois, il est à constater que 
                                          les zones autour de l'Aire, qui sont, rappelons-le, des corridors verts, ont des moyennes
                                          peu élevées, ce qui n'est donc pas un point positif pour permettre d'avoir des corridors de 
                                          qualité pour les espèces de faune.")
                                   )),
                          fluidRow(leafletOutput("fragmap", width = "900px"), br()),
                          fluidRow(
                            box(width= 12, title= "Explication de la carte", status= "warning", solidHeader = TRUE,
                                collapsible = TRUE,
                                h3("La représentation cartographique ci-dessus permet dans un premier temps de visualiser les moyennes
                                   par quartier sur la commune de Lancy, et de pouvoir ainsi localiser chaque quartier sur la carte.
                                   De plus, la carte pour tout Genève a été ajoutée, afin de se rendre compte de la distribution sur le
                                   terrain. Grâce à cette carte, on voit clairement le centre urbain et les axes routiers traversant le canton.
                                   Tout cela crée des barrières empêchant la circulation des espèces à travers le canton.")
                                )),
                          helpText("Données: Ge21, Projet RPT - Indicateurs Services Ecosystémiques"),
                          fluidRow(actionButton(inputId = "precedent8", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant8", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  tabItem(tabName = "ind_lumineuse",
                          h2("Indicateur: Pollution lumineuse"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("Dans nos sociétés, de plus en plus en d'émissions lumineuses sont présentes (éclairage
                                          routier, panneaux publicitaires, etc.). Cependant, ces sources lumineuses peuvent avoir
                                          des effets néfastes sur la faune et la flore, en particulier pour les espèces dépendantes
                                          de la nuit: désorientation, barrières infranchissables créées par ces sources, altération
                                          du rythme biologique, sont des exemples des effets nuisibles pour ces espèces.
                                          De plus, selon l'OFEV, dans la région du Plateau en Suisse, il n'y aurait plus un endroit
                                          totalement obscure la nuit", 
                                          tags$a(href="https://www.bafu.admin.ch/dam/bafu/fr/dokumente/biodiversitaet/uz-umwelt-zustand/biodiversitaet-schweiz-zustand-entwicklung.pdf.download.pdf/UZ-1630-F_2017-06-20.pdf. ", 
                                                                              "(Source: OFEV, 2017)."), br(),
                                          "Pour toutes ces raisons, il semble donc pertinent d'appréhender cette thématique
                                          afin de pouvoir renseigner sur les endroits potentiellement pollués par la lumière, 
                                          et également comparer ces résultats avec les lieux d'importance pour la biodiversité
                                          sur la commune."))),
                          fluidRow(leafletOutput("lum", width = "900px"), br()),
                          fluidRow(
                            box(width= 12, title= "Explication de la carte", status= "warning", solidHeader = TRUE,
                                h3("Sur le territoire cantonal genevois, peu de données sont actuellement disponibles. 
                                   En effet, cette thématique est en plein boom et des travaux sont en cours à Genève 
                                   afin de pouvoir évaluer cette question. La seule donnée disponible à ce jour est 
                                   donc une orthophoto nocturne datant de 2013 sur le SITG.", br(), 
                                   "Cette première 
                                   représentation cartographique permet de visualiser que les routes sont les plus éclairées de nuit 
                                   (les endroits les plus éclairés sont les zones de la commune en jaune et les endroits les plus
                                   obscures en rouge foncé), et il 
                                   est à constater qu’elles créent des barrières à travers le territoire de la commune, 
                                   pouvant être problématiques pour les espèces se déplaçant de nuit. La zone de 
                                   l’Aire, importante pour les passages à faune,
                                   semble, ici, être préservée de la pollution lumineuse, même si il serait important d’avoir 
                                   d’autres résultats afin de pouvoir valider cette conclusion. Cet indicateur est donc en 
                                   construction, d’autres données devraient être disponibles au cours de cette année afin 
                                   de pouvoir mieux évaluer et représenter la pollution lumineuse sur le territoire communal 
                                   et cantonal.")
                                )),
                          helpText("Données en provenance du SITG"),
                          fluidRow(actionButton(inputId = "precedent9", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant9", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  tabItem(tabName = "ind_agricole",
                          h2("Indicateur: Pollution agricole"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("Cet indicateur permet d’évaluer les éléments chimiques qui se diffusent dans les sols.
                                          Ces éléments sont utilisés en particulier dans l’agriculture, mais certains
                                          d'entre eux sont également relâchés par la végétation. Ils
                                          sont nécessaires, cependant
                                          une trop grande dose peut amener à une pollution des sols et avoir des effets 
                                          néfastes pour les écosystèmes environnants. De plus, les sols agricoles ne sont 
                                          pas les seuls concernés, puisque les substances sont exportées via le ruissellement
                                          et peuvent donc se retrouver dans des sols autres qu'agricoles.
                                          Un surplus de ces produits peut ainsi causer des problèmes aux écosystèmes. 
                                          Par exemple, trop de phosphore va causer des problèmes dans les milieux 
                                          aquatiques avec l’augmentation d’algues, la diminution du taux d’oxygène, 
                                          et la dégradation de la diversité dans les sols", 
                                          tags$a(href="https://www.bafu.admin.ch/dam/bafu/fr/dokumente/biodiversitaet/uw-umwelt-wissen/umweltziele_landwirtschaftstatusbericht.pdf.download.pdf/umweltziele_landwirtschaftstatusbericht.pdf", 
                                                 "(Source: OFEV et OFAGE, 2016)."), br(),
                                          "Il semble donc pertinent d’estimer les endroits sensibles à la pollution 
                                          par ces éléments chimiques, afin de minimiser les conséquences pour 
                                          la biodiversité. Les données utilisées représentent la dispersion de l'azote
                                          et du phosphore sur le territoire cantonal."))),
                          fluidRow(
                            tabBox(width = "1200px",
                              tabPanel("Azote", color= "blue", leafletOutput("mapPollAgriN", width = "900px"), br(),
                                       fluidRow(
                                         box(title= "Résultats pour le Canton",
                                             status= "success", solidHeader= TRUE, plotOutput("azoteGE_boxplot")), 
                                         box(title= "Résultats pour Lancy",
                                             status= "success", solidHeader= TRUE, plotOutput("azoteLancy_boxplot")))),
                              tabPanel("Phosphore", leafletOutput("mapPollAgriP", width = "900px"),br(),
                                       fluidRow(
                                         box(title= "Résultats pour le Canton",
                                             status= "success", solidHeader= TRUE, 
                                             plotOutput("phosphoreGE_boxplot")), 
                                         box(title= "Résultats pour Lancy",
                                             status= "success", solidHeader= TRUE,  
                                             plotOutput("phosphoreLancy_boxplot"))))),
                            style= 'padding:15px', align= "center"
                            ),
                          fluidRow(box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("Les résultats les plus élevés indiquent les endroits les plus sensibles 
                                          à la pollution, car c’est là où, après la filtration, le phosphore et/ou 
                                          l’azote peuvent se retrouver. Grâce aux boxplots, il a été remarqué que le 
                                          territoire lancéen semble être moins sujet à 
                                          l’accumulation d’azote que le reste du territoire cantonal, cependant il 
                                          y a beaucoup de valeurs extrêmes. Cette même tendance se voit également pour 
                                          le phosphore où l’intervalle interquartile est très resserré et la médiane est 
                                          plus faible que celle du canton. De plus, cet intervalle est très proche des 
                                          valeurs de 0. Cette tendance semble cohérente du fait que la commune est presque 
                                          totalement en zone urbaine. Cependant, il est intéressant de remarquer qu’il y a 
                                          quand même certaines zones sensibles à ce type de pollution, dûe au ruissellement.
                                          ", br(),
                                          "Au niveau de la représentation cartographique, les résultats permettent de 
                                          montrer les zones où peut se concentrer la pollution à chacune des substances 
                                          mentionnées précédemment. Au niveau communal, il est à noter que ce sont les 
                                          zones autour de l’Aire et du Rhône qui sont les plus sensibles à ce type de 
                                          pollution. Cependant, avec ces valeurs, on ne peut pas déterminer à partir de 
                                          quand une certaine dose devient un problème et peut réellement avoir des effets sur les
                                          écosystèmes. Il s'agit donc plus de données informatives permettant de déceler où
                                          se retrouvent ces éléments chimiques, et de se rendre des zones plus ou moins sensibles.")
                                       )),
                          helpText("Données: Travail de Master E. Honeck (2017) "),
                          fluidRow(actionButton(inputId = "precedent10", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant10", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  tabItem(tabName = "ind_sonore",
                          h2("Indicateur: Pollution sonore"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("Dans nos sociétés, le bruit devient constant et la tranquillité un luxe. 
                                          Des valeurs seuils d'exposition au bruit ont été déterminées afin de ne pas 
                                          avoir des effets néfastes pour la santé humaine. De manière globale, 
                                          les valeurs seuils générales sont de 60dB le jour et de 50dB la nuit.
                                          Si ces valeurs sont déterminées afin de ne pas atteindre la santé humaine,
                                          le bruit impact également la faune, même si il y a beaucoup d'inconnues sur le sujet.
                                          Plusieurs études ont montré les effets néfastes liés au bruit: stress, impossibilité
                                          de se déplacer, de se nourrir, de communiquer, sont des exemples de ces effets.
                                          Même si la littérature sur la pollution sonore sur la faune reste souvent 
                                          confinée à certaines espèces, il est fondamental de constater les 
                                          effets du bruit anthropique sur les espèces de faune et c’est pourquoi cet 
                                          indicateur a été choisi afin de représenter les zones soumises à des pollutions sonores.",
                                          br(), "Les valeurs définies pour la santé humaine vont être prises comme seuils,
                                          car il n'y a pas de valeurs seuils pour les espèces de faune. Le but est de pouvoir percevoir
                                          les zones sensibles au bruit, et cela pourrait permettre de soulager la pression 
                                          sur certaines zones infranchissables pour les espèces. De plus, seules les données concernant
                                          le trafic routier ont été prises en considération, car le bruit routier est une des sources
                                          principales de nuisances de bruit pour les espèces de faune."))),
                          fluidRow(box(width= 12, title= "Résultats par commune", status= "success", solidHeader= TRUE,
                                       plotlyOutput("plotBruit", width = "800px", height = "1200px"))),
                          fluidRow(valueBoxOutput("Bruit_jourR_pourcentage", width = 6),
                                   valueBoxOutput("Bruit_nuitR_pourcentage", width = 6), style= 'padding:10px', align= "center"),
                          fluidRow(box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("Les résultats du graphique montrent qu’environ 30% du territoire lancéen est soumis à des valeurs 
                                          supérieures aux seuils recommandés, de jour comme de nuit. La commune se place donc dans 
                                          les premières places au niveau cantonal (en calculant une surface relative par commune).
                                          Ce sont d'ailleurs les endroits les plus urbanisés du canton qui sont en tête
                                          , ce qui fait sense, au vu de l'importance du trafic routier dans le centre urbain à Genève.",
                                          br(), "La représentation cartographique ci-dessous permet de montrer où sont les lieux, sur le 
                                          canton et à l’échelle communale, les plus soumis au bruit routier. Cela permet donc 
                                          de voir que la zone autour de l’Aire, considérée comme une des zones importantes 
                                          selon les indicateurs de qualité de la biodiversité, est soumise à beaucoup de bruit. 
                                          Même si on ne connait pas de valeurs seuils pour les espèces de faune,  les résultats 
                                          autour de l’Aire dépassent déjà les seuils pour les êtres humains, donc il peut être 
                                          envisagé que le bruit dans cette zone a des impacts pour les espèces de faune les plus 
                                          sensibles à ce type de nuisances.")
                                       )),
                          fluidRow(tabBox(width = "1200px",
                            tabPanel("Canton", "Carte du canton", leafletOutput("mapbruitGE", width = "900px")),
                            tabPanel("Commune", "Carte de la commune de Lancy", leafletOutput("mapbruitLANCY", width = "900px"))
                          ), style= 'padding:15px', align= "center"),
                          helpText("Données en provenance de l'OFEV"),
                          fluidRow(actionButton(inputId = "precedent11", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant11", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  tabItem(tabName = "ind_imper",
                          h2("Indicateur: Taux d'imperméabilisation des sols"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("L'imperméabilisation des sols est une conséquence de l'urbanisation intensive dans
                                          nos sociétés actuelles. Le problème est qu'en imperméabilisant les sols, cela les empêche
                                          de pouvoir stocker de l'eau pendant des périodes de grosses pluies, et donc amène potentiellement
                                          à des inondations plus rapidement. De plus, l'eau, sécoulant en surface, n'est plus stockée par les 
                                          sols et donc n'est plus disponible pour la végétation environnante. Les sols sont aussi importants
                                          pour stocker du carbone, en les imperméabilisant cet usage n'est plus disponible. Enfin, les 
                                          sols sont utiles pour notre alimentation, de ce fait en décidant de les recouvrir, on ne
                                          peut plus y produire nos propres denrées. De plus, les sols imperméables créent des îlots de
                                          chaleur en période de canicule. Tous ces éléments ont donc des conséquences pour 
                                          les écosystèmes environnants, mais également pour la santé humaine. Il paraît donc important
                                          de connaître la surface imperméable sur la commune, de préserver les zones qui ne le sont pas,
                                          et de pouvoir prédire les endroits problèmatiques en fonction de ce phénomène (tels que les
                                          inondations par exemple).
                                          "))),
                          fluidRow(box(width= 12, title= "Résultats par commune", status= "success", solidHeader= TRUE,
                                       plotlyOutput("plotImper", width = "800px", height = "1000px"), br())),
                          fluidRow(box(width= 8, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("Les résultats graphiques mettent en lumière que la commune est l’une des plus 
                                          imperméables du canton (avec plus de 55% de son territoire imperméable). 
                                          La carte ci-dessous permet de distinguer
                                          qu’à l’échelle communale les zones autour de l’Aire et tangentes au Rhône 
                                          sont les principales zones perméables de la commune. 
                                          A l’échelle cantonale, les résultats n'ont pas pu être cartographiés, car la couche 
                                          utilisée était trop lourde à projeter.")
                                       ),
                                   valueBoxOutput("imper_Lancy_pourcentage")),
                          fluidRow(leafletOutput("impermap", width = "900px")
                          ),
                          fluidRow(),
                          helpText("Données en provenance du SITG"),
                          fluidRow(actionButton(inputId = "precedent12", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant12", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  ###Bénéfices###
                  tabItem(tabName = "presentation_benefit", 
                          fluidRow(box(title= h2("Catégorie: Pressions sur la biodiversité"), status= "danger",  
                                       h3("Les bénéfices regroupent ici tous les impacts que nous retirons de la biodiversité.
                                          Ces bénéfices sont de plus en plus étudiés sous le nom de services écosystémiques.
                                          Il s'agit donc des avantages issus de la biodiversité qui sont utiles à 
                                          l'être humain. Sans ces bénéfices nous ne pourrions vivre de la même manière que nous
                                          le faisons actuellement. Il s'agit par exemple des ressources alimentaires que nous
                                          en retirons, de la régulation du climat, des bénfécies esthétiques que les écosystèmes nous procurent,
                                          etc. Les services écosystémiques sont répartis en quatre catégories: services
                                          d'approvisionnement, services de soutien, services culturels et de régulation. L'image
                                          ci-dessous permet d'illustrer cette catégorisation et des exemples de services rendus par la 
                                          biodiversité.
                                          Ces services sont primoridaux pour nous, il est donc impératif de pouvoir les évaluer
                                          afin de pouvoir au mieux les préserver.",
                                          tags$img(
                                            src="services_eco1.png", height= 600, width=650, style="display: block; margin-left: 
                                            auto; margin-right: auto;"), br(), 
                                          div(style="text-align:center", #permet de centrer qu'une partie du texte
                                              "Source:", 
                                              tags$a(href="https://www.ge.ch/document/strategie-biodiversite-geneve-2030/telecharger", 
                                                     "DGAN, 2018", align="center")),
                                          br(), "Les deux indicateurs choisis, pour évaluer cette catégorie, sont les suivants:", br(), br(),
                                          div( 
                                            actionButton(inputId= "ind_poll1", "Pollinisation", style= "background-color: #c4edaf"),
                                            actionButton(inputId= "ind_carbone1", "Stockage du carbone", style= "background-color: #c4edaf"),
                                            style="text-align:center"), br(), br(), "D'autres indicateurs de bénéfices devraient
                                          alimenter cette catégorie dans le futur. En effet, une étude menée par", 
                                          tags$a(href="http://www.ge21.ch/", "GE-21"), "est en cours
                                          et a pour but d'évaluer les services écosystémiques du canton de Genève. 
                                          Cette catégorie sera donc amenée
                                          à évoluer, afin d'avoir une vision plus aboutie des bénéfices retirés de la biodiversité.")
                                       , width= 12, align= "center")),
                          fluidRow(actionButton(inputId = "precedent13", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant13", label = "Indicateur suivant"), align= "center")
                  ),
                  tabItem(tabName = "ind_pollinisation",
                          h2("Indicateur: Pollinisation"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("La pollinisation est un des services que nous retirons de la biodiversité. Elle est primordiale
                                          pour notre sécurité alimentaire, puisque la majorité des plantes sont dépendantes des pollinisateurs.
                                          Ils ont donc un rôle centrale dans l'agriculture mondiale, sans eux une grande partie des ressources que 
                                          nous produisons aujourd'hui ne serait possible.", br(), "Le problème est que les pollinisateurs, et en
                                          particulier les colonies d'abeilles, sont
                                          menacés par différents facteurs, pesticides, virus, qualité des habitats et malnutrition sont des
                                          exemples d'agents affaiblissants, et dans certains cas, détruisants ces pollinisateurs. Il faut se rendre 
                                          compte de la gravité de la situation et de l’importance de la pollinisation pour notre société. Prenons 
                                          l'exemple de si les abeilles venaient à disparaître: cela aurait pour conséquences de choisir ce que l'on
                                          peut ou non produire, mais surtout, cela aurait une conséquence sur le prix des aliments qui se mettrait
                                          à croître du fait de la rareté des produits. En prenant le
                                          point de vue uniquement de notre bien-être, il est important de prendre conscience de ce service et de visualiser
                                          les zones d'importance pour celui-ci, afin de les maintenir ou les restaurer. Mais il est également important 
                                          de faire en sorte que des mesures soient prises sur le terrain afin d'atténuer, dans la mesure du possible, les 
                                          menaces pesant sur les pollinisateurs et d'améliorer leurs conditions de vie. Cela permettrait 
                                          d'avoir également des bénéfices sur la biodiversité dans son ensemble, qui souffrirait en premier lieu de la perte de ces espèces.
                                          ", br(), "Deux données ont été utilisées pour illustrer ce service, il s'agit de l'abondance des pollinisateurs sur le 
                                          territoire cantonale, ainsi que de la valeur économique de ce bénéfice. La première indique les 
                                          endroits où il y a des zones de nidification et d’alimentation proche, qui permettent donc 
                                          aux pollinisateurs de s'y établir, et permet d’identifier les zones les plus propices pour 
                                          les espèces étudiées (16 espèces ont été étudiées dans l'étude d'où sont tirées les données). La seconde couche représente 
                                          la valeur économique liée au service de pollinisation, cependant les valeurs ne sont pas en monnaie 
                                          réelle mais en unité relative, et n’a été faite que en fonction d’une espèce à savoir le Bombus terrestris.", 
                                          br(),
                                          "La vidéo ci-dessous permet de résumer en profondeur le problème de la disparition des colonies d'abeilles,
                                          exemple marquant de la perte des pollinisteurs (Source vidéo:",
                                          tags$a(href="https://www.youtube.com/watch?v=453zpj3nDIU", "Le Monde)."), br(), br(),
                                          div(style="text-align:center",tags$iframe(width="560", height="315", 
                                                      src="https://www.youtube.com/embed/453zpj3nDIU", frameborder="0", 
                                                      allow="autoplay; encrypted-media", allowfullscreen= "true"))))),
                          fluidRow(
                            tabBox(width = "1200px",
                              tabPanel("Abondance des pollinisateurs",leafletOutput("mappollinisateurs_abondance", 
                                                                                width = "900px"), br(),
                                       fluidRow(box(title= "Résultats pour le Canton",
                                                    status= "success", solidHeader= TRUE, plotOutput("abondanceGE_boxplot")), 
                                                box(title= "Résultats pour Lancy",
                                                    status= "success", solidHeader= TRUE, plotOutput("abondanceLancy_boxplot")))), 
                              tabPanel("Valeur économique", leafletOutput("mappollinisateurs_eco",
                                                                          width = "900px"), br(),
                                       fluidRow(box(title= "Résultats pour le Canton",
                                                    status= "success", solidHeader= TRUE, plotOutput("val_ecoGE")), 
                                                box(title= "Résultats pour Lancy",
                                                    status= "success", solidHeader= TRUE, plotOutput("val_ecoLancy_boxplot"))))),
                            style= 'padding:15px', align= "center"
                          ),
                          fluidRow(box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("La pollinisation a donc été représentée par deux couches : 
                                          l’abondance de pollinisateurs et la valeur économique du service de pollinisation. 
                                          Pour l’abondance des pollinisateurs, on remarque que Lancy a une distribution de 
                                          l’intervalle interquartile moins étalée et plus concentrée proche de la médiane, 
                                          et qui plus est, plus proche des valeurs basses que le reste canton. Il y aurait donc, 
                                          à priori, une tendance à une abondance moins importante à Lancy par rapport au reste 
                                          du canton. Cette même tendance se retrouve pour les résultats de la valeur économique : 
                                          Lancy a quasiment toutes ses données à zéro, avec un certain nombre de valeurs extrêmes. 
                                          La commune semble donc ne pas être un territoire favorable à ce type de service, en 
                                          comparaison des résultats du canton.", br(), 
                                          "Deux représentations cartographiques ont également été produites afin de visualiser 
                                          ces résultats. Les résultats les plus hauts pour l’abondance de pollinisateurs se situent dans la zone 
                                          proche du Rhône. Pour la valeur économique, comme dit précédemment, presques toutes les valeurs de la
                                          commune sont à zéro, cependant certaines tâches avec des valeurs un petit peu plus élevées se
                                          distinguent légèremment, également distribuées vers les berges du Rhône.
                                          ")
                                       )),
                          helpText("Données: Travail de Master V. Ruiz (2014)"),
                          fluidRow(actionButton(inputId = "precedent14", label = "Présentation précédente"),
                                   actionButton(inputId = "suivant14", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  tabItem(tabName = "ind_carbone",
                          h2("Indicateur: Carbone"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("Le deuxième indicateur développé dans cette catégorie est la capacité 
                                          des territoires à stocker le carbone. Les émissions de CO2 existe depuis 
                                          toujours, cependant, depuis l’ère industrielle, nous n’avons pas cessé 
                                          d’en émettre d’avantage (dû principalement à la déforestation et aux combustions d'énergies fossiles
                                          ). Le problème est que cela crée un surplus de CO2. En effet, il y a différents puits de carbone 
                                          qui permettent de stocker le CO2: les océans, la végétation et les sols. 
                                          Le problème est que ces puits ne sont pas infinis. Il y a donc une surplus d'émissions de CO2 chaque année relâché 
                                          dans l’atmosphère. Ce surplus va contribuer à l'augmentation de l'émissions de gaz à effet de serre, et donc 
                                          a un rôle majeur dans le réchauffement climatique.", br(),
                                          "Dans cet optique, il est important de prendre en considération ce service et de pouvoir au mieux changer, améliorer 
                                          la gestion et/ou protéger les zones nécessaires 
                                          au maintien de ce service."))),
                          fluidRow(box(title= "Résultats pour le Canton",
                                       status= "success", solidHeader= TRUE, plotOutput("carboneBoxplotGE")), 
                                   box(title= "Résultats pour Lancy",
                                       status= "success", solidHeader= TRUE, plotOutput("carboneBoxplotLancy"))),
                          fluidRow(
                            box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                h3("Les résultats des boxplots semblent très proches entre la commune et le canton avec une distribution 
                                    de l’intervalle interquartile très étalée autour de la médiane. La représentation 
                                    cartographique ci-dessous permet, elle, de visualiser les résultats et de prendre conscience 
                                    des zones les plus importantes en termes de capacité à stocker du carbone. Celle-ci rend compte
                                    de l'importance des zones autour du Rhône et de l'Arve à l'échelle de Lancy pour ce service.
                                   ")
                          )),
                          fluidRow(
                            leafletOutput("mapcarbone", width = "900px")
                          ),
                          helpText("Données: Travail de Master V. Ruiz (2014)"),
                          fluidRow(actionButton(inputId = "precedent15", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant15", label = "Indicateur suivant")),
                          align= "center"),
                  ###Résultats###
                  tabItem(tabName = "presentation_resultats", 
                          fluidRow(box(title= h2("Catégorie: Résultats des mesures pour la biodiversité"), status= "danger",  
                                       h3("La dernière catégorie choisie est les mesures prises en faveur de la biodiversité.
                                          En effet, il est primordial de pouvoir évaluer les résultats des mesures prises en faveur de la biodiversité,
                                          car le biodiversité se dégrade de plus en plus, de ce fait il est important de 
                                          savoir ce qui est mis en place, et comment elles sont mises en place, afin d'atteindre au mieux
                                          les objectifs souhaités.", br(),
                                          "Afin d'illustrer cette catégorie, quatre indicateurs, de différentes natures, ont
                                          été développés:", br(), br(),
                                          div( 
                                            actionButton(inputId= "ind_espaces1", "Espaces protégés", style= "background-color: #edcbaf"),
                                            actionButton(inputId= "ind_SPB1", "Surfaces de promotion de la biodiversité", style= "background-color: #edcbaf"),
                                            br(), br(),
                                            actionButton(inputId= "ind_invest1", "Investissements pour la biodiversité", style= "background-color: #edcbaf"),
                                            actionButton(inputId= "ind_prog1", "Programmes de sensibilisation", style= "background-color: #edcbaf"),
                                            style="text-align:center"))
                                       , width= 12, align= "center")),
                          fluidRow(actionButton(inputId = "precedent16", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant16", label = "Indicateur suivant"),align="center")
                  ),
                  tabItem(tabName = "ind_protege",
                          h2("Indicateur: Espaces protégés"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("L'un des objectifs au niveau mondial, avec la Convention sur la Diversité Biologique,
                                          ainsi qu'aux niveaux nationaux, et cantonaux, est d'atteindre, d'ici 2020, 17% de 
                                          territoire terrestre protégé. Cependant, en Suisse comme à Genève, ce seuil n'est pas 
                                          atteint. Il faut donc un suivi, afin de visualiser et estimer les surfaces protégées,
                                          et potentiellement identifier celles qui devraient l'être. En Suisse, certaines zones
                                          ont été définies comme aires protégées et sont donc régulées en fonction de certains critères.
                                          De plus, les cantons ont décidé de mettre en place certaines zones sous protection.",
                                          br(), "Sur Genève, différents types d'aires protégées sont présents, en voici un récapitulatif:
                                          ", div(style= 'padding:15px',
                                          tags$li(tags$b("Les zones humides liées à la Convention Ramsar"),": 
                                                  protection des espaces humides, avec un point focal sur les habitats pour 
                                                  les oiseaux d’eau .", tags$a(href="https://www.bafu.admin.ch/bafu/fr/home/themen/thema-biodiversitaet/biodiversitaet--daten--indikatoren-und-karten/biodiversitaet--indikatoren/indikator-biodiversitaet.pt.html/aHR0cHM6Ly93d3cuaW5kaWthdG9yZW4uYWRtaW4uY2gvUHVibG/ljL0FlbURldGFpbD9pbmQ9QkQwMjMmbG5nPWZyJlN1Ymo9Tg%3d%3d.html ", "(Source: OFEV, 2017)")
                                                  ),
                                          tags$li(tags$b("L'Inventaire fédéral des paysages et des monuments 
                                                  naturels de signification nationale"),": protège
                                                  «des paysages à préserver et des monuments naturels d'importance nationale».",
                                                  tags$a(href="https://ge.ch/sitg/fiche/7114 ", "(Source: SITG)")),
                                          tags$li(tags$b("L'Inventaire fédéral des zones alluviales d’importance nationale"),": répertorie les zones alluviales 
                                                  suivant un certain nombre de critères, tel que l’aire ou le type de recouvrement .",
                                                  tags$a(href="https://ge.ch/sitg/fiche/9860 ", "(Source: SITG)")),
                                          tags$li(tags$b("L'Inventaire fédéral des sites de reproduction des batraciens fixes"), ": 
                                                  au vu de la grande menace pesant sur les espèces de batraciens en Suisse 
                                                  (presque tous sur liste rouge), les habitats propices à ces espèces 
                                                  ont été mis sous protection. Cette donnée au niveau cantonale référence désormais 
                                                  également l’Inventaire fédéral des sites de reproduction des batraciens 
                                                  itinérants et la proposition de périmètre OBAT 2010-2011.",
                                                  tags$a(href="https://ge.ch/sitg/fiche/5846", "(Source: SITG)")),
                                          tags$li(tags$b("L'Inventaire fédéral des prairies et pâturages secs"), ": 
                                                  en danger, ces milieux singuliers dans les espèces qu’ils 
                                                  abritent sont sous protection.",
                                                  tags$a(href="https://ge.ch/sitg/fiche/7276 ", "(Source: SITG)")),
                                          tags$li(tags$b("L'Inventaire fédéral des bas-marais d’importance nationale"), ": 
                                                  ces espaces regroupent «une biocénose composée de plantes 
                                                  et d'animaux étroitement liés les uns aux autres et 
                                                  parmi lesquels se trouve un grand nombre d'espèces menacées»",
                                                  tags$a(href="https://ge.ch/sitg/fiche/7872 ", "(Source: SITG)")),
                                          tags$li(tags$b("Les Réserves naturelles et plans de site"), ": 
                                                  Répertorie les espaces naturels «bénéficiant d'une protection 
                                                  légale en faveur de la nature» définis en fonction 
                                                  d’inventaires nationaux, cantonaux et d’avis d’experts. Ces deux 
                                                  types d’espaces sont définis en fonction du règlement sur la 
                                                  protection du paysage, des milieux naturels et de la flore 
                                                  (RPPMF, L 4 05.11) et de la loi sur la protection des monuments, 
                                                  de la nature et des sites (LPMNS, L 4 05).",
                                                  tags$a(href="https://ge.ch/sitg/fiche/5271", "(Source: SITG)")))
                                          ))),
                          fluidRow(box(title= "Résultats pour le Canton",
                                       status= "success", solidHeader= TRUE,plotlyOutput("pieCanton")), 
                                   box(title= "Résultats pour Lancy",
                                       status= "success", solidHeader= TRUE,plotlyOutput("pieLancy")), br()),
                          fluidRow(box(width= 12, title= "Résultats par commune", status= "success", solidHeader= TRUE,
                                       collapsible = TRUE,
                                           plotlyOutput("plotEP", width="900px", height= "1000px")), br()),
                          fluidRow(box(width= 8, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("L’indicateur des espaces protégés a permis d’évaluer la surface 
                                          relative par commune identifiée comme faisant partie de ces catégories. 
                                          La commune de Lancy, avec presque 6% de son territoire en espaces protégés, 
                                          se situe dans les communes avec une part faible de protection de leur territoire. 
                                          Les communes en queue de peloton sont également les plus urbanisées du canton, 
                                          ce qui fait sens aux résultats trouvés ci-dessus. Les zones protégées de la 
                                          commune de Lancy le sont par deux types d’inventaires : l’Inventaire fédéral 
                                          des paysages et des monuments naturels de signification nationale et la 
                                          Convention Ramsar. Au niveau cantonal, sept types de protection sont identifiés 
                                          et grâce à un graphique en secteurs, il est possible de voir le pourcentage 
                                          que chaque type de protection représente sur le territoire du canton.", br(),
                                          "La représentation cartographique, présentée ci-dessous, permet de visualiser où se situe 
                                          chaque type de protection sur le territoire. Au niveau communal, c’est à 
                                          nouveau la zone proche du Rhône qui est concernée par des aires protégées.")
                                       ),
                                   valueBoxOutput("espacesprotvaluebox"), br()),
                          fluidRow(leafletOutput("mapespaces", width = "900px")),
                          helpText("Données en provenance du SITG"),
                          fluidRow(actionButton(inputId = "precedent17", label = "Présentation précédente"),
                                   actionButton(inputId = "suivant17", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  tabItem(tabName = "ind_compensation",
                          h2("Indicateur: Surfaces de promotion de la biodiversité (SPB)"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("En Suisse, des mesures sont prises au niveau des 
                                          surfaces agricoles et des prairies. Il s’agit des 
                                          surfaces de promotion de la biodiversité (SPB). Elles sont 
                                          définies comme telles car étant « exploitées de manière extensive » 
                                          (mise en jachère, prairies, haies, etc.) et sont 
                                          donc développées en zone agricole. Ces surfaces sont bénéfiques 
                                          pour la biodiversité, car elles mettent à disposition des habitats 
                                          vitaux pour les espèces vivants en zone agricole et permettent d’atténuer 
                                          les menaces pesantes sur certaines espèces dans ces zones. Pour avoir mis ces surfaces
                                          en SPB, les exploitants sont retribués. Cet indicateur permet d’offrir 
                                          une vision des efforts consentis dans le but de préserver la biodiversité.",
                                          tags$a(href="https://www.bafu.admin.ch/dam/bafu/fr/dokumente/biodiversitaet/fachinfo-daten/ausgewiesene-gebiete-fuer-biodiversitaet.pdf.download.pdf/aires-consacr%C3%A9es-%C3%A0-la-biodiversit%C3%A9.pdf ", 
                                                 "(Source: OFEV)")
                                          ))),
                          fluidRow(box(width=12, title= "Résultats par commune", status= "success", solidHeader= TRUE,
                                       collapsible = TRUE, plotlyOutput("plotSC", height= "1000px"))),
                          fluidRow(box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("Cet indicateur montre qu’à Lancy presque la totalité 
                                          des prairies présentes font parties des SPB. En effet, le graphique
                                          en barre, calculant la surface de SPB en fonction de 
                                          la surface totale des parcelles agricoles et des prairies 
                                          pour chaque commune, a permis de révéler que Lancy fait 
                                          partie des communes qui ont le plus de SPB par rapport 
                                          à leur surface totale de prairies et de cultures – les 
                                          prairies et cultures représentants 3.75% de la commune 
                                          et les SPB 3.41%. Cette représentation permet de voir 
                                          comment les parcelles sont gérées.", br(), br(),
                                          valueBoxOutput(width= 6, "mesuresvaluebox1"),valueBoxOutput(width= 6, "mesuresvaluebox2"),
                                          br(), "De plus, une carte 
                                          a été créée afin de pouvoir visualiser, où sur le territoire 
                                          du canton de Genève, se situe chaque SPB. Une option a été ajoutée 
                                          afin de pouvoir aller questionner la carte dans le but de savoir à quelle 
                                          catégorie de surface chaque parcelle correspond. Pour se faire, il suffit d'aller par dessus
                                          le polygone, dont on souhaite avoir les informations, et une fenêtre s'ouvre avec 
                                          les informations le concernant.")
                                       ), br()),
                          fluidRow(leafletOutput("mapmesures", width = "900px")),
                          helpText("Données en provenance du SITG"),
                          fluidRow(actionButton(inputId = "precedent18", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant18", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  tabItem(tabName = "ind_investissement",
                          h2("Indicateur: Quantification des investissements pour la biodiversité"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("Pour mettre en place toutes les mesures existantes sur le terrain, 
                                          il y a un besoin financier. Les investissements pour la biodiversité 
                                          sont donc primordiaux afin d’évaluer les moyens qui sont mis en 
                                          place pour arriver à développer des projets en faveur de la biodiversité. Ici, le choix
                                          s'est porté de prendre en considération toutes les mesures prises 
                                          dans le but d’atténuer les pressions sur la biodiversité et en fonction de leur durée de vie."))),
                          fluidRow(
                            box(width=12, title= "Résultats des investissements dans le temps", status= "success", solidHeader= TRUE,
                                plotlyOutput(outputId = "timeseries", height = "600px")
                          )),
                          fluidRow(box(width= 12, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("Les résultats montrent que des investissements sont petit-à-petit mis en place 
                                          depuis 2010. En effet, depuis 2010, des nichoirs pour oiseaux, chauves-souris et
                                          hérissons ont été mis en place (au total presque 90 nichoirs ont été posés).
                                          Différentes mesures ont été prises comme des haies vives plantées ou entretenues
                                          en fonction, des tas de bois, de branches et de pierres ont été installés. Notons
                                          encore que les SPB, présentées dans l'indicateur précédent, font parties de ce type
                                          d'investissements que la commune a décidé de faire.", br(), "De plus, depuis 2017,
                                          le centre de production de la commune s'est reconverti dans la production BIO. La gestion
                                          des parcs de la commune a fait de même depuis début 2018. Enfin, le commune vise
                                          avoir le label Bourgeon de Bio-Suisse dès 2019 (pour plus d'information sur le Bourgeon
                                          Bio-Suisse:", tags$a(href="https://www.bio-suisse.ch/fr/ ", "cliquer ici"), "). (Source:
                                          communication personnelle du Service de l'Environnement de la commune de Lancy)", br(),
                                          "Toutefois, il est à identifier que la monétarisation de ces données n'a pas pu être
                                          récoltée. Cet indicateur apporte tout de même des informations importantes, permettant
                                          de visualiser les investissements mis en place sur le terrain et leur durée de vie. Il semble pertinent
                                          de voir son évolution, d'ajouter de nouvelles données, et dans la mesure du possible,
                                          d'avoir les investissements monétaires de ces mesures.")
                                       ), br()),
                          helpText("Données en provenance de la commune de Lancy"),
                          fluidRow(actionButton(inputId = "precedent19", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant19", label = "Indicateur suivant")),
                          align= "center"
                  ),
                  tabItem(tabName = "ind_programme",
                          h2("Indicateur: Quantitié de programmes de sensibilisation"),
                          fluidRow(box(width= 12, title= "Présentation", status= "primary", solidHeader= TRUE, collapsible = TRUE,
                                       h3("Tous les indicateurs, développés précédemment, concernent directement 
                                          la biodiversité ou les professionnels des milieux, il est donc intéressant 
                                          d’avoir un indicateur qui sorte de ces catégories, et qui puisse évaluer 
                                          comment l’information sur la biodiversité est émise au-delà des spécialistes. 
                                          C’est pour cela qu’un indicateur recensant tous les programmes de 
                                          sensibilisation mis en place a été choisi. Il permet ainsi de visualiser comment
                                          la population locale peut-être sensibilisée à la biodiversité."))),
                          fluidRow(box(width=12, title= "Résultats des investissements dans le temps", status= "success", solidHeader= TRUE,
                                       plotlyOutput("progsensi", height = "250px")), br()),
                          fluidRow(box(width= 6, title= "Explication des résultats", status= "warning", solidHeader = TRUE,
                                       h3("Les résultats montrent que des programmes  
                                          se développent depuis 2015, 
                                          mais qu’ils prennent sans doute plus de temps à être réalisés, ce qui 
                                          pourrait être dû à des coûts financiers et de ressources humaines, qu’ils engendrent.
                                          Le graphique réalisé permet de voir l’évolution 
                                          temporelle des programmes et leur durée de vie. 
                                          De plus, c’est une information permettant d’estimer 
                                          ce qui est fait pour sensibiliser directement le grand public. On peut ainsi y lire
                                          qu'un potager communal a été mis en place depuis 2015, dans lequel
                                          les enfants des écoles communales sont sensibilisés. Un autre projet devrait
                                          voir le jour d'ici le printemps prochain: à savoir la mise en place d'un rucher,
                                          ayant également pour but la sensibilisation pour les écoles (Source: 
                                          communication personnelle du Service de l'Environnement de Lancy).", br(), "La carte
                                          ci-joint permet de visualiser où ont lieu ces programmes.
                                          De plus, des liens reliant chaque programme à son site web ont été conçus 
                                          afin de pouvoir améliorer la visibilité de ces programmes. 
                                          D’autres données pourraient être ajoutées au cours du temps, 
                                          telles que les festivals et animations mis en place dans le futur.")
                                          ),
                                   leafletOutput("prog_sensimap",width = "400px")),
                          helpText("Données en provenance de la commune de Lancy"),
                          fluidRow(actionButton(inputId = "precedent20", label = "Indicateur précédent"),
                                   actionButton(inputId = "suivant20", label = "Retour accueil")),
                          align= "center"
                  )
                  )
                  )
              )
