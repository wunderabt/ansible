kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secrets | grep admin-user | awk '{print $1}')
