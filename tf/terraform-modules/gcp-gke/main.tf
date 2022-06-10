
resource "google_container_cluster" "gke" {
  #Needed for Config Connector
  provider = google-beta
  name                      = var.cluster_name
  location                  = var.cluster_location
  remove_default_node_pool  = true                 #node version can only be specified if this value is false
  initial_node_count        = 1
  description               = var.cluster_description
  default_max_pods_per_node = 110
  network                   = var.vpc_network
  subnetwork                = var.vpc_subnetwork
  # node_version              = var.node_version
  min_master_version        = var.min_master_version

  # tags = {
	# 	Name = local.name
	# }


  # node_config {
  #   machine_type = var.machine_type
  #   image_type   = "COS_CONTAINERD"
  #   disk_size_gb = var.node_disk_size
  #   tags         = var.node_tags
  # }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.mastercidrblock
    master_global_access_config {
      enabled = true
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.master_authorized_cidr_1
      display_name = var.master_authorized_cidr_1_name
    }
    cidr_blocks {
      cidr_block   = var.master_authorized_cidr_2
      display_name = var.master_authorized_cidr_2_name
    }
    cidr_blocks {
      cidr_block   = var.master_authorized_cidr_3
      display_name = var.master_authorized_cidr_3_name
    }
    cidr_blocks {
      cidr_block   = var.master_authorized_cidr_4
      display_name = var.master_authorized_cidr_4_name
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
  }

  network_policy {
    enabled = true
  }

  release_channel {
    channel = "REGULAR"
  }

  vertical_pod_autoscaling {
    enabled = false
  }

  notification_config {
    pubsub {
      enabled = false
      #  topic = google_pubsub_topic.notifications.id
    }
  }
  maintenance_policy {
    recurring_window {
      start_time = "2022-03-17T07:00:00Z"
      end_time   = "2022-03-17T13:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
    }
  }

  addons_config {
    config_connector_config {
      enabled = true
    }
    network_policy_config {
      disabled = false
    }
  }
}

resource "google_container_node_pool" "primary_node_pool" {
  name               = var.node_pool_name
  location           = var.cluster_location
  cluster            = google_container_cluster.gke.name
  initial_node_count = var.pool_node_count
  node_locations     = var.node_locations

  autoscaling {
    min_node_count = var.min_node_count_per_zone
    max_node_count = var.max_node_count_per_zone
  }

  node_config {
    machine_type = var.machine_type
    image_type   = "COS_CONTAINERD"
    disk_size_gb = var.node_disk_size
    tags         = var.node_tags

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_upgrade = var.nodes_auto_upgrade
    auto_repair  = var.nodes_auto_repair
  }
}

/******************************************
  Static Global IPv4 reservation (HTTPS LB)
 *****************************************/

resource "google_compute_global_address" "cloudmc-ingress-ip" {
  name = var.cloudmc-ingress-ip
}

/******************************************
  SSL Policy (HTTPS LB)
 *****************************************/

resource "google_compute_ssl_policy" "cloudmc-ssl-policy" {
  name            = var.cloudmc-ssl-policy
  profile         = "RESTRICTED"
  min_tls_version = "TLS_1_2"
}

/******************************************
  Cloud Armor policy
 *****************************************/

resource "google_compute_security_policy" "cloudmc-security-policies" {
  name = "cloudmc-security-policies"

  rule {
    action   = "allow"
    priority = "900"
    preview  = false

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = [
          "20.103.218.56/29",
          "20.54.106.120/29",
        ]
      }
    }

    description = "CMC-234"
  }
  rule {
    action   = "allow"
    priority = "950"

    match {

      expr {
        expression = "evaluatePreconfiguredExpr('sqli-stable', ['owasp-crs-v030001-id942400-sqli', 'owasp-crs-v030001-id941180-xss', 'owasp-crs-v030001-id930110-lfi', 'owasp-crs-v030001-id931130-rfi'])"
      }
    }

    description = "CMC-326"
  }

  rule {
    action   = "deny(403)"
    priority = "990"
    preview  = false

    match {
      expr {
        expression = "request.headers['host'].contains('acme') && '[RU,IR,CU,SY,KP,UA-43,TR,UA,VE,BY,AF,CN,TM-B,BI,CF,CD,ET,GN,GW,IQ,LB,LY,ML,MM,NI,SO,SS,SD,YE,ZW,AD,AE,AG,AI,AL,AM,AO,AQ,AR,AS,AT,AU,AW,AX,AZ,BA,BD,BE,BF,BG,BH,BJ,BL,BM,BN,BO,BQ,BR,BS,BT,BV,BW,BZ,CC,CG,CH,CI,CK,CL,CM,CO,CR,CV,CW,CX,CY,CZ,DE,DJ,DK,DM,DO,DZ,EC,EE,EG,EH,ER,ES,FI,FJ,FK,FM,FO,FR,GA,GB,GD,GE,GF,GG,GH,GI,GL,GM,GP,GQ,GR,GS,GT,GU,GY,HK,HM,HN,HR,HT,HU,ID,IE,IE,IL,IM,IN,IO,IS,IT,JE,JM,JO,JP,KE,KG,KH,KI,KM,KN,KR,KW,KY,KZ,LA,LC,LI,LK,LR,LS,LT,LU,LV,MA,MC,MD,ME,MF,MG,MH,MK,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ,NA,NC,NE,NF,NG,NL,NO,NP,NR,NU,NZ,OM,PA,PE,PF,PL,PM,PN,PR,PS,PT,PW,PY,QA,RE,RO,RS,RW,SA,SB,SC,SE,SH,SI,SJ,SK,SL,SM,SN,SR,ST,SV,SX,SZ,TC,TD,TF,TG,TH,TJ,TK,TL,TM,TN,TO,TT,TV,TW,TZ,UG,UM,UY,UZ,VA,VC,VG,VI,VN,VU,WF,WS,YT,ZA,ZM]'.contains(origin.region_code)"
      }
    }

    description = "Test CMC 167"
  }
  rule {
    action   = "deny(403)"
    priority = "1000"

    match {

      expr {
        expression = "evaluatePreconfiguredExpr('xss-stable', ['owasp-crs-v030001-id941330-xss', 'owasp-crs-v030001-id941340-xss', 'owasp-crs-v030001-id941120-xss', 'owasp-crs-v030001-id941320-xss', 'owasp-crs-v030001-id941110-xss', 'owasp-crs-v030001-id941130-xss', 'owasp-crs-v030001-id941140-xss', 'owasp-crs-v030001-id941170-xss', 'owasp-crs-v030001-id941150-xss', 'owasp-crs-v030001-id941160-xss'])"
      }
    }

    description = "Deny access to all IPs on xss attack match"
  }


  rule {
    action   = "deny(403)"
    priority = "1001"

    match {

      expr {
        expression = "evaluatePreconfiguredExpr('sqli-stable', ['owasp-crs-v030001-id942432-sqli', 'owasp-crs-v030001-id942431-sqli', 'owasp-crs-v030001-id942430-sqli', 'owasp-crs-v030001-id942260-sqli', 'owasp-crs-v030001-id942340-sqli', 'owasp-crs-v030001-id942200-sqli', 'owasp-crs-v030001-id942421-sqli', 'owasp-crs-v030001-id942420-sqli', 'owasp-crs-v030001-id942110-sqli', 'owasp-crs-v030001-id942440-sqli', 'owasp-crs-v030001-id942440-sqli', 'owasp-crs-v030001-id942300-sqli', 'owasp-crs-v030001-id942460-sqli', 'owasp-crs-v030001-id942330-sqli', 'owasp-crs-v030001-id942380-sqli', 'owasp-crs-v030001-id942210-sqli', 'owasp-crs-v030001-id942120-sqli','owasp-crs-v030001-id942140-sqli','owasp-crs-v030001-id942450-sqli', 'owasp-crs-v030001-id942190-sqli', 'owasp-crs-v030001-id942410-sqli', 'owasp-crs-v030001-id942150-sqli','owasp-crs-v030001-id942180-sqli'])"
      }
    }

    description = "Deny access to all IPs on sqli attack match"
  }

  rule {
    action   = "deny(403)"
    priority = "1002"

    match {

      expr {
        expression = "evaluatePreconfiguredExpr('lfi-stable', ['owasp-crs-v030001-id930120-lfi'])"
      }
    }

    description = "Deny access to all IPs on lfi attack match"
  }

  rule {
    action   = "deny(403)"
    priority = "1003"

    match {

      expr {
        expression = "evaluatePreconfiguredExpr('rfi-stable')"
      }
    }

    description = "Deny access to all IPs on rfi attack match"
  }

  rule {
    action   = "deny(403)"
    priority = "1004"

    match {

      expr {
        expression = "evaluatePreconfiguredExpr('rce-stable', ['owasp-crs-v030001-id932120-rce', 'owasp-crs-v030001-id932160-rce','owasp-crs-v030001-id932100-rce','owasp-crs-v030001-id932110-rce','owasp-crs-v030001-id932130-rce', 'owasp-crs-v030001-id932105-rce'])"
      }
    }

    description = "Deny access to all IPs on rce attack match"
  }
  rule {
    action   = "allow"
    priority = "2147483647"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }

    description = "Default rule, higher priority overrides it"
  }
}


/******************************************
 Cloud KMS (Vault unsealer)
 *****************************************/

# Create a KMS key ring
resource "google_kms_key_ring" "key_ring" {
  project  = var.project_id
  name     = var.key_ring
  location = var.region_id
}

# Create a crypto key for the key ring
resource "google_kms_crypto_key" "crypto_key" {
  name            = var.crypto-key
  key_ring        = google_kms_key_ring.key_ring.self_link
  rotation_period = "100000s"
}

# Add the service account to the Keyring
resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  key_ring_id = google_kms_key_ring.key_ring.id
  role        = "roles/cloudkms.cryptoKeyEncrypter" #was Owner previously

  members = [
    "serviceAccount:gke-vault-unsealer@${var.project_id}.iam.gserviceaccount.com",
  ]
}
