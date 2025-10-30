resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.security.name
  principal_arn = data.aws_iam_user.admin.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.security.name
  principal_arn = data.aws_iam_user.admin.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
