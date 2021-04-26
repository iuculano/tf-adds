#-------------------------------------------------------------------------------
# Maybe this should be split to primary / others?
#-------------------------------------------------------------------------------
output "instance_ids" {
  value       = aws_instance.this.*.id
  description = "The id of the instances created to be domain controllers."
}
