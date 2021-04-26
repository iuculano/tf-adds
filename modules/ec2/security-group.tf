#-------------------------------------------------------------------------------
# Main AD firewall exceptions
# 
# This is potentially not needed if staying within the bounds of the VPC
# because the default SG may allow the ingress. This will be useful if the
# VPC needs to communicate over VPN or similar.
#-------------------------------------------------------------------------------
resource "aws_security_group" "ad_cloud" {
    name        = "SG - Active Directory"
    description = "Ports for Active Directory"
    vpc_id      = var.vpc_id

    
    # DNS
    ingress {
        from_port   = 53
        to_port     = 53
        protocol    = "tcp"
        description = "DNS"
        cidr_blocks = var.cidr_blocks
    }

    ingress {
        from_port   = 53
        to_port     = 53
        protocol    = "udp"
        description = "DNS"
        cidr_blocks = var.cidr_blocks
    }
    
    # W32Time
    ingress {
        from_port   = 123
        to_port     = 123
        protocol    = "udp"
        description = "W32Time"
        cidr_blocks = var.cidr_blocks
    }

    # RPC Endpoint Mapper
    ingress {
        from_port   = 135
        to_port     = 135
        protocol    = "tcp"
        description = "RPC Endpoint Mapper"
        cidr_blocks = var.cidr_blocks
    }
    
    # LDAP
    ingress {
        from_port   = 389
        to_port     = 389
        protocol    = "tcp"
        description = "LDAP"
        cidr_blocks = var.cidr_blocks
    }

    ingress {
        from_port   = 389
        to_port     = 389
        protocol    = "udp"
        description = "LDAP"
        cidr_blocks = var.cidr_blocks
    }

    # LDAP SSL
    ingress {
        from_port   = 636
        to_port     = 636
        protocol    = "udp"
        description = "Kerberos password change"
        cidr_blocks = var.cidr_blocks
    }

    # LDAP GC/SSL
    ingress {
        from_port   = 3268
        to_port     = 3269 # Limit the range to 3268 to exclude LDAP GC SSL
        protocol    = "tcp"
        description = "LDAP GC/SSL"
        cidr_blocks = var.cidr_blocks
    }

    # SMB
    ingress {
        from_port   = 445
        to_port     = 445
        protocol    = "tcp"
        description = "SMB"
        cidr_blocks = var.cidr_blocks
    }
    
    # Kerberos
    ingress {
        from_port   = 88
        to_port     = 88
        protocol    = "tcp"
        description = "Kerberos"
        cidr_blocks = var.cidr_blocks
    }

    ingress {
        from_port   = 88
        to_port     = 88
        protocol    = "udp"
        description = "Kerberos"
        cidr_blocks = var.cidr_blocks
    }

    # Kerberos password change
    ingress {
        from_port   = 464
        to_port     = 464
        protocol    = "tcp"
        description = "Kerberos password change"
        cidr_blocks = var.cidr_blocks
    }

    ingress {
        from_port   = 464
        to_port     = 464
        protocol    = "udp"
        description = "Kerberos password change"
        cidr_blocks = var.cidr_blocks
    }

    # RPC ephemeral ports
    ingress {
        from_port   = 49152
        to_port     = 65535
        protocol    = "tcp"
        description = "RPC ephemeral ports"
        cidr_blocks = var.cidr_blocks
    }    

    # ICMP
    ingress {
        from_port   = 8
        to_port     = 0
        protocol    = "icmp"
        description = "ICMP Ping"
        cidr_blocks = var.cidr_blocks
    }


    # OUTBOUND
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
