---
rbac:
  create: true
  ## Use an existing ClusterRole/Role (depending on rbac.namespaced false/true)
  # useExistingRole: name-of-some-(cluster)role
  pspEnabled: true
  pspUseAppArmor: true
  namespaced: false
  extraRoleRules: []
  # - apiGroups: []
  #   resources: []
  #   verbs: []
  extraClusterRoleRules: []
  # - apiGroups: []
  #   resources: []
  #   verbs: []

serviceAccount:
  create: true
  name: ${grafana_service_account_name}
  nameTest:
  annotations:
    eks.amazonaws.com/role-arn: ${grafana_iam_role_arn}

autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      targetAverageUtilization: 60
  - type: Resource
    resource:
      name: memory
      targetAverageUtilization: 60

persistence:
  enabled: false
  # type: pvc
  # storageClassName: default
  # accessModes:
  #   - ReadWriteOnce
  # size: 10Gi
  # # annotations: {}
  # finalizers:
  #   - kubernetes.io/pvc-protection
  # # selectorLabels: {}
  # # subPath: ""
  # # existingClaim:

persistence:
  enabled: false
  # type: pvc
  # storageClassName: default
  # accessModes:
  #   - ReadWriteOnce
  # size: 10Gi
  # annotations: {}
  # finalizers:
  #   - kubernetes.io/pvc-protection
  # # selectorLabels: {}
  # # subPath: ""
  # # existingClaim:
  inMemory:
    enabled: true
    sizeLimit: 300Mi

adminUser: admin
# adminPassword: strongpassword

# Use an existing secret for the admin user.
# admin:
#   existingSecret: ""
#   userKey: admin-user
#   passwordKey: admin-password

plugins:
  - grafana-piechart-panel
  - grafana-kubernetes-app

datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        url: http://${prom_svc}
        access: proxy
        isDefault: true
        basicAuth: false
        withCredentials: false
        editable: true
      - name: Loki
        type: loki
        url: http://${loki_svc}
        isDefault: false
        basicAuth: false
        withCredentials: false
        editable: true
      - name: CloudWatch
        type: cloudwatch
        access: proxy
        uid: cloudwatch
        editable: false
        jsonData:
          authType: default
          defaultRegion: ${aws_region}

