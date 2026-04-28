# Statistiques avec R
# 2026-04-28

# Packages ----

library(dplyr)
library(writexl)
library(ggplot2)

# Importer les donnees ----

dataScores <- read.csv2("data/ScoresEleves.csv", na.strings = "")

# 2.9 Caracterisation d'un data frame ----

# Afficher les dimensions
dim(dataScores)

# Afficher les noms des variables
names(dataScores)
colnames(dataScores)

# Afficher les quelques premieres lignes
head(dataScores, 5)

# Afficher les quelques dernieres lignes
tail(dataScores, 5)

# 2.10 Acceder a differentes parties d'un data frame ----

# ligne 2 et colonne 3
dataScores[2, 3]

# ligne 2 et toutes les colonnes
dataScores[2, ]

# lignes 1 a 4, colonne 2
dataScores[1:4, 2]

# lignes 1 a 4, toutes les colonnes sauf la colonne 2
dataScores[1:4, -2]

# lignes 2 et 5, colonnes 6 et 4
dataScores[c(2, 5), c(6, 4)]

# selectionner des colonnes en utilisant leurs intitules
dataScores$Score5
mean(dataScores$Score5)

# Selectionner des colonnes a l'aide du package {dplyr}
select(dataScores, Origine, Score5)

# Selectionner tout sauf Origine et Score5
select(dataScores, -Origine, -Score5)

# Selectionner toutes les colonnes dont l'intitule renferme
# la chaine de caracteres Score
select(dataScores, contains("Score"))

# Selectionner des lignes suivant des conditions : 
# tous les eleves avec Score4 > 90
filter(dataScores, Score4 > 90)

# eleves d'origine O1, Score1 > 50
filter(dataScores, Origine == "O1", Score1 > 50)

# exclure tous les eleves de l'etablissement C
filter(dataScores, Etablissement != "C")

# 2.11 Trier un data frame ----

# Trier par ordre croissant de Score1
arrange(dataScores, Score1)

# Trier par ordre decroissant de Score1
arrange(dataScores, -Score1)

# Trier par ordre d'Etablissement suivi d'un ordre decroissant de Score3
arrange(dataScores, Etablissement, -Score3)

# 2.12 Creer de nouvelles colonnes dans un data frame ----

# Syntaxe classique : moyenne scores 4 et 5
dataScores$MoyenneS4S5 <- (dataScores$Score4 + dataScores$Score5) / 2

# Fonction mutate()
mutate(dataScores, 
       MoyenneS4S5 = (Score4 + Score5) / 2,
       MoyenneS1S2 = (Score1 + Score2) / 2)

# Supprimer une colonne
select(dataScores, -Score1)

# 2.13 Calculs automatises sur chaque colonne ----

# Syntaxe classique
# Calcul de la moyenne des eleves par score
apply(dataScores[, 5:9], MARGIN = 2 , mean)

# Calcul de la moyenne des scores pour chaque eleve
apply(dataScores[, 5:9], MARGIN = 1 , mean)

# Fonction summarise()
summarise(dataScores, across(where(is.numeric), ~mean(.x, na.rm = TRUE)))

# Extraire les colonnes numeriques d'un data frame
dataScoresNum <- select(dataScores, where(is.numeric))
apply(dataScoresNum, MARGIN = 2, mean)

# 2.14 Calculs automatises sur chaque colonne ----

# Etape 1 : creer un regroupement autour d'une variable groupe
groupOrigine <- group_by(dataScores, Origine)

# Etape 2 : calculer la moyenne de Score1 par Origine
summarise(groupOrigine, moyS1 = mean(Score1))

# Il est possible d'enchainer plusieurs calculs groupes
# dans la fonction summarise()
summarise(groupOrigine, 
          moyS1 = mean(Score1),
          moyS2 = mean(Score2))

# Executer un calcul groupe sur chaque colonne d'un data frame
summarise(groupOrigine, across(where(is.numeric), ~mean(.x)))

# Calcul de moyenne par etablissement et origine
groupEtabOrigine <- group_by(dataScores, Etablissement, Origine)

ResultatMoyenes <- summarise(groupEtabOrigine, 
          moyS1 = mean(Score1),
          moyS2 = mean(Score2))

# Exporter un data frame au format Excel
write_xlsx(ResultatMoyenes, "data/Resultats_moyennes.xlsx")

# 2.15 Graphiques avec ggplot2 ----

# Construction d'une base graphique
ggplot(data = dataScores,
       mapping = aes(x = Score1, y = Score5,
                     color = Origine))

# Ajout d'un premier calque a la base graphique
ggplot(data = dataScores,
       mapping = aes(x = Score1, y = Score5,
                     color = Origine)) +
  geom_point()

# Enchainement de calques - exemple 1
ggplot(data = dataScores,
       mapping = aes(x = Score1, y = Score5,
                     color = Origine)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Test de la fonction ggplot()",
       x = "Score obtenu a l'examen 1",
       y = "Score obtenu a l'examen 5") +
  theme_bw()

# Enchainement de calques - exemple 2
ggplot(data = dataScores,
       mapping = aes(x = Score1, y = Score5,
                     color = Origine)) +
  geom_point() +
  facet_wrap(~Etablissement) +
  scale_color_manual(values = c("red", "darkgreen", "#00008B"))
  theme_bw()