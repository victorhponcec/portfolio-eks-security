resource "aws_eks_access_entry" "admin" {
  for_each      = toset(local.eks_admin_users)
  cluster_name  = aws_eks_cluster.security.name
  principal_arn = each.value
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  for_each      = toset(local.eks_admin_users)
  cluster_name  = aws_eks_cluster.security.name
  principal_arn = each.value

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
/*
resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.security.name
  principal_arn = data.aws_iam_user.admin.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.security.name
  principal_arn = data.aws_iam_user.terraform.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
  }
  */