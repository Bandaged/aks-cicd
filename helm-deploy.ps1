helm upgrade $(HELM_DEPLOYMENT_NAME) $(CHART_FOLDER) \
  --install \
  -n $(HELM_NS) \
  --create-namespace \
  -f $(HELM_DEPLOYMENT_VALUES_FILE) \
  --debug \
  --timeout 25m0s