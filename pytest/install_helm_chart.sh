helm install selenium-grid tss-helm/tss-selenium-grid \
    --set author=258741 \
    --set node.chrome.replicas=1 \
    --set node.firefox.replicas=1 \
    --namespace selenium
