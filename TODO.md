# TODO - Prochaines étapes

## 1. Déploiement en ligne
- GitHub Actions + GitHub Container Registry : CI/CD pour build et push des images Docker
- Déploiement cloud : Render, Railway, ou Fly.io (gratuits pour petits projets)
- Alternative : Posit Connect Cloud ou shinyapps.io pour les frontends Shiny

## 2. Améliorer le modèle ML
- Ajouter des métriques (RMSE, MAE) sur un jeu de test
- Tester d'autres algorithmes (Random Forest, XGBoost)
- Implémenter le versioning du modèle avec MLflow ou DVC

## 3. Enrichir les frontends
- Ajouter des visualisations (graphiques des prédictions, distribution des données)
- Historique des prédictions
- Comparaison côte-à-côte Python vs R

## 4. Tests automatisés
- Tests unitaires pour l'API (pytest)
- Tests d'intégration pour les frontends
- Tests de bout en bout avec les containers

## 5. Documentation Quarto
- Compléter le notebook `model-vetiver.qmd` avec l'analyse exploratoire
- Ajouter une page "Architecture" avec diagrammes
- Publier le site sur GitHub Pages
