terraform {
  required_version = ">= 1.5"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

variable "raspberry_ip" {
  description = "IP de la Raspberry Pi"
  type        = string
}

variable "ssh_user" {
  description = "Usuario SSH"
  type        = string
  default     = "fernando"
}

variable "ssh_private_key" {
  description = "Ruta a la clave privada SSH"
  type        = string
  default     = "~/.ssh/id_rsa"
}

resource "null_resource" "raspberry_provision" {
  connection {
    type        = "ssh"
    host        = var.raspberry_ip
    user        = var.ssh_user
    private_key = file(var.ssh_private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "echo '=== CONEXIÓN SSH EXITOSA DESDE TERRAFORM ==='",
      "echo 'IP actual: ' $(hostname -I)",
      "echo 'Sistema: ' $(uname -a)",
      "echo 'Docker: ' $(docker --version)",
      "echo 'Usuario: ' $(whoami)",
      "echo 'Grupos: ' $(groups)",
      "echo '=== TODO CORRECTO ==='",
      
      # === NUEVAS LÍNEAS: INSTALACIÓN DE DEPENDENCIAS ===
      "echo '=== INSTALANDO DEPENDENCIAS DE AUDIO ==='",
      "sudo apt update",
      "sudo apt install -y pipewire pipewire-pulse wireplumber",
      "pactl load-module module-null-sink sink_name=virtual_sink",
      "pactl load-module module-virtual-source source_name=virtual_source master=virtual_sink.monitor",
      "sudo apt install -y python3-pip python3-venv git",
      "git clone https://github.com/your-demo/translator-demo.git /home/fernando/translator || true",
      "echo '=== VERIFICACIÓN FINAL ==='",
      "pactl info | grep 'Server Name' || echo 'PipeWire no instalado'",
      "python3 --version",
      "echo '=== TODO LISTO PARA MODELO DE TRADUCCIÓN ==='"
    ]
  }
}

# Los outputs quedan IGUAL, no los toques
output "resultado" {
  value = "Raspberry Pi (${var.raspberry_ip}) provisionada correctamente con Terraform"
}

output "ip_utilizada" {
  value = var.raspberry_ip
}

output "mensaje_final" {
  value = "Infraestructura validada. Listo para desplegar modelo de traducción."
}