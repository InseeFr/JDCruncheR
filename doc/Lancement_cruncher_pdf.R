## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
    echo = TRUE, size = "small"
)
library("JDCruncheR")
library("kableExtra")
library("knitr")

## ----echo=FALSE, eval=FALSE---------------------------------------------------
#  refresh_policy <- structure(list(`Option sous JDemetra+` = c("Fixed model",
#  "Estimate regression coefficients",
#  "Estimate regression coefficients + Arima parameters",
#  "Estimate regression coefficients + Last outliers",
#  "Estimate regression coefficients + all outliers",
#  "Estimate regression coefficients + Arima model",
#  "Concurrent"), `Option du cruncher` = c("current", "fixedparameters (ou fixed)",
#  "parameters (paramètre par défaut)", "lastoutliers", "outliers",
#  "stochastic", "complete ou concurrent"), Signification = c("Le modèle ARIMA, les outliers et les autres paramètres du modèle de régression ne sont ni ré-identifiés ni ré-estimés. Le schéma de décomposition est inchangé.",
#  "Le modèle ARIMA, les outliers et les autres paramètres du modèle regARIMA ne sont pas ré-identifiés. Les coefficients du modèle ARIMA sont fixés et les autres paramètres du modèle de régression sont ré-estimés. Le schéma de décomposition est inchangé.",
#  "Le modèle ARIMA, les outliers et les autres paramètres du modèle de régression ne sont pas ré-identifiés mais sont tous ré-estimés. Le schéma de décomposition est inchangé.",
#  "Le modèle ARIMA, les outliers (sauf ceux de la dernière année) et les autres paramètres du modèle de régression ne sont pas ré-identifiés mais sont tous ré-estimés. Les outliers de la dernière année sont ré-identifiés. Le schéma de décomposition est inchangé.",
#  "Le modèle ARIMA et les paramètres du modèle regARIMA autres que les outliers ne sont pas ré-identifiés mais ré-estimés. Tous les outliers sont ré-identifiés. Le schéma de décomposition est inchangé.",
#  "Ré-identification de tous les paramètres du modèle regARIMA hormis les variables calendaires. Le schéma de décomposition est inchangé.",
#  "Ré-identification de tout le modèle regARIMA.")), .Names = c("Option sous JDemetra+",
#  "Option du cruncher", "Signification"), class = "data.frame", row.names = c(NA,
#  -7L))
#
#  kable(refresh_policy, caption = "Les différentes politiques de rafraîchissement",
#        booktabs = TRUE, format = "latex") %>%
#      kable_styling(full_width = T,
#                    latex_options = "hold_position") %>%
#      group_rows("Partial concurrent adjustment", 1, 6) %>%
#      group_rows("Concurrent", 7, 7) %>%
#      column_spec(1, width = "4cm") %>%
#      column_spec(2, width = "2.5cm")
#
#

## ---- eval = FALSE------------------------------------------------------------
#  library("JDCruncheR")
#   # Pour afficher les paramètres par défaut :
#  getOption("default_matrix_item")
#  # Pour modifier les paramètres par défaut pour n'exporter par exemple
#  # que les critères d'information :
#  options(default_matrix_item = c("likelihood.aic",
#                                  "likelihood.aicc",
#                                  "likelihood.bic",
#                                  "likelihood.bicc"))

## ---- eval = FALSE------------------------------------------------------------
#   # Pour afficher les paramètres par défaut :
#  getOption("default_tsmatrix_series")
#  # Pour modifier les paramètres par défaut pour n'exporter par exemple que
#  # la série désaisonnalisées et ses prévisions :
#  options(default_tsmatrix_series = c("sa", "sa_f"))

## ---- eval = FALSE------------------------------------------------------------
#  # Un fichier parametres.param sera créé sous D:/ avec la politique de rafraîchissement
#  # "lastoutliers" et les autres paramètres par défaut
#  create_param_file(dir_file_param = "D:/",
#                    policy = "lastoutliers")
#
#  # Si l'on a modifié les options "default_matrix_item" et "default_tsmatrix_series" pour
#  # n'exporter que les critères d'information, la série désaisonnalisée et ses
#  # prévisions, la commande précédente est équivalent à :
#  create_param_file(dir_file_param = "D:/",
#                    policy = "lastoutliers",
#                    matrix_item = c("likelihood.aic", "likelihood.aicc",
#                                    "likelihood.bic", "likelihood.bicc"),
#                    tsmatrix_series = c("sa", "sa_f"))

## ---- eval = FALSE------------------------------------------------------------
#  options(cruncher_bin_directory = "D:/jdemetra-cli-2.2.3/bin/")

## ---- eval = FALSE------------------------------------------------------------
#  # La commande suivante permet de mettre à jour le workspace "ipi" présent sous
#  # D:/Campagne_CVS/ avec l'option de rafraîchissement "lastoutliers". Les autres
#  # options de lancement du cruncher sont ceux par défaut de la fonction create_param_file().
#  # En particulier, les paramètres exportés sont ceux des options "default_matrix_item"
#  # et "default_tsmatrix_series", et les résultats sortent sous D:/Campagne_CVS/Output/.
#  cruncher_and_param(workspace = "D:/Campagne_CVS/ipi.xml",
#                     rename_multi_documents = FALSE,
#                     policy = "lastoutliers")
#
#  # Utilisation du paramètre "output" pour changer le dossier contenant les résultats :
#  cruncher_and_param(workspace = "D:/Campagne_CVS/ipi.xml",
#                     output = "D:/Resultats campagne/",
#                     rename_multi_documents = FALSE,
#                     policy = "lastoutliers")
#
#  # Pour modifier les noms des dossiers contenant les sorties afin qu'ils soient égaux
#  # aux noms des multi-documents affichés dans l'application JDemetra+ il suffit
#  # d'utiliser le paramètre "rename_multi_documents = TRUE" (valeur par défaut).
#  # Le paramètre "delete_existing_file = TRUE" permet, lui, de supprimer éventuels
#  # dossiers existants portant le même nom qu'un des multi-documents.
#  cruncher_and_param(workspace = "D:/Campagne_CVS/ipi.xml",
#                     rename_multi_documents = TRUE,
#                     delete_existing_file = TRUE,
#                     policy = "lastoutliers")
#
#  # Pour voir les autres paramètres de la fonction :
#  ?cruncher_and_param
