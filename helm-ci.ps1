helm template $(HELM_DEPLOYMENT_NAME) $(CHART_FOLDER) \
  -f $(CHART_FOLDER)/values.yaml \
  -f $(CHART_FOLDER)/values.test.yaml

helm dependency build $(CHART_FOLDER)

helm package $(CHART_FOLDER) -d $(HELM_OUTPUT_FOLDER)

