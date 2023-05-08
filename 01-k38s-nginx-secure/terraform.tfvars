token=""
k8s_label="terraform-k8s"
k8s_region="ap-south"
tags=["terraform-k8s", "terraform"]
pools=[
    {
        type = "g6-standard-1"
        count = 3
    }
]
