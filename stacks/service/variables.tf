variable "kortnavn" {
  description = "Kortnavnet ditt. Settes i config/felles.tfvars."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,10}$", var.kortnavn))
    error_message = "kortnavn må være 2–10 små bokstaver eller tall. Sett det i config/felles.tfvars."
  }
}

variable "location" {
  description = "Azure-regionen. Settes i config/felles.tfvars."
  type        = string
}

variable "miljo" {
  description = "Miljøet. Settes av scripts/kjor.sh (TF_VAR_miljo), ikke i en .tfvars-fil."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.miljo)
    error_message = "miljo må være dev eller prod."
  }
}

variable "tjeneste" {
  description = "Hvilken tjeneste denne instansen av service-stacken er for. Et lavercase navn uten tall eller spesialtegn, f.eks. ordre, meny, sok."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2,15}$", var.tjeneste))
    error_message = "tjeneste må være 2-15 små bokstaver, uten tall eller spesialtegn."
  }
}

variable "runtime" {
  description = "Kjøremiljøet til denne tjenesten: vm eller webapp."
  type        = string

  validation {
    condition     = contains(["vm", "webapp"], var.runtime)
    error_message = "runtime må være vm eller webapp."
  }
}

variable "vm_size" {
  description = "VM-størrelsen, kun brukt når runtime er vm."
  type        = string
  default     = "Standard_B2als_v2"
}

variable "ssh_public_key" {
  description = "Offentlig SSH-nøkkel, kun brukt når runtime er vm. Ikke hemmelig."
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMQ32gu8mGVI86gkUex5JsBeg7WC58bsUOVuxmeHDJW oblig2-ingen-privat-nokkel"
}

variable "webapp_sku" {
  description = "SKU for App Service-planen, kun brukt når runtime er webapp."
  type        = string
  default     = "B1"
}

variable "subnet_prefix" {
  description = "Adresseområdet til denne tjenestens subnett, f.eks. 10.10.0.0/24. Flyttet fra network.tfvars."
  type        = string
}

variable "allow_http_from" {
  description = "Hvem som får nå tjenesten på port 80."
  type        = string
  default     = "Internet"
}
