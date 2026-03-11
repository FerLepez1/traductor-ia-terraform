# 🗣️ Traducción Simultánea con IA + Raspberry Pi 5 + Failover con Terraform

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Proof of Concept](https://img.shields.io/badge/Status-PoC%20Functional-green)]()
[![Terraform](https://img.shields.io/badge/IaC-Terraform-844FBA)](https://www.terraform.io)
[![Raspberry Pi](https://img.shields.io/badge/Edge-RPi%205-red)](https://www.raspberrypi.com)
[![Oracle Cloud](https://img.shields.io/badge/Cloud-OCI%20Always%20Free-F80000)](https://www.oracle.com/cloud)

> **⚠️ PROYECTO EN CONSTRUCCIÓN ACTIVA (Marzo 2026)**
> Este es un proyecto de arquitectura de infraestructura para IA conversacional. Las fases principales de IaC están completas y funcionales. La integración final del modelo de IA está en progreso.

## 📈 Logros Clave (Key Achievements)

*   **Arquitectura Híbrida Automatizada:** Diseño e implementación de un sistema que orquesta un nodo Edge (Raspberry Pi 5) y un failover en Cloud (Oracle Cloud ARM) usando **Terraform**.
*   **Provisionamiento Ultra-Rápido:** Reducción del tiempo de configuración de un servidor de traducción de **horas a <5 segundos** mediante Infraestructura como Código (IaC) idempotente.
*   **Resiliencia Incorporada:** Mecanismo de **failover automático** planificado para garantizar la continuidad del servicio de traducción sin intervención manual.
*   **Latencia de Estado del Arte:** Preparado para desplegar modelos S2ST modernos (como Voxtral) que ofrecen **<200ms de latencia** con preservación de la voz del hablante, un hito para la conversación natural.
*   **Independencia de Plataforma:** Sistema de audio virtual (basado en PipeWire) que permite la inyección de audio traducido en **cualquier aplicación de videollamada** (Zoom, Teams, Meet), funcionando tanto como anfitrión o invitado.

## 📊 Logros con Métricas (Impacto Cuantificable)

| Área de Mejora | Situación Inicial / Alternativas Comerciales | Logro Alcanzado / Objetivo del Proyecto |
| :--- | :--- | :--- |
| **Tiempo de Aprovisionamiento** | Configuración manual de un servidor: **horas o días**. | Reducción a **<5 segundos** con `terraform apply`. |
| **Costo Operativo Anual** | Suscripción a Zoom AI Companion u otro servicio similar: **> $240 USD/año**. | **$0 USD/año** (usando hardware propio y capa gratuita de OCI). |
| **Tiempo de Recuperación (RTO)** | Dependencia de un solo dispositivo; fallo = servicio caído hasta reparación manual. | Objetivo: **Failover automático en <1 minuto** a la nube. |
| **Privacidad de Datos** | El audio se procesa en servidores de terceros (Zoom, Google, etc.). | **Control total de datos**: procesamiento local en hardware propio. |

## 💡 El Problema que Resolvemos

Las herramientas comerciales de traducción simultánea (Zoom AI Companion, etc.) presentan limitaciones críticas para un caso de uso profesional y exigente:

*   **Alta Dependencia:** Solo funcionan si eres el anfitrión y pagas una suscripción.
*   **Falta de Privacidad:** El audio se procesa en servidores de terceros sin control sobre los datos.
*   **Caja Negra:** Imposibilidad de personalizar el modelo con vocabulario técnico específico.
*   **Costo Recurrente:** Suscripciones mensuales que se acumulan.

**Nuestra solución** es una arquitectura de infraestructura abierta, automatizada y resiliente que pone el control en manos del usuario, con costo operativo cercano a cero y un rendimiento de vanguardia.

## 🏗️ Arquitectura de la Solución (NetDevOps Approach)

El sistema sigue un flujo de trabajo declarativo y automatizado, similar a GitOps:

1.  **Declaración del Estado:** La configuración del servidor de traducción se define como código en Terraform.
2.  **Orquestación Híbrida:** Terraform aprovisiona y configura tanto el nodo principal (Raspberry Pi 5) como la instancia de respaldo en Oracle Cloud.
3.  **Zero-Touch Provisioning:** El nodo Edge se configura automáticamente con **cloud-init** y scripts de Terraform, instalando Docker, PipeWire y todas las dependencias.
4.  **Resiliencia Activa:** Un sistema de *health checks* monitoriza el nodo principal. Ante una caída, ejecuta un `terraform apply` para activar el failover en la nube.
5.  **Traducción Invisible:** Un modelo de IA (Voxtral/Latent Linguist) corre en el nodo activo. El audio de la llamada se captura y se inyecta de vuelta mediante dispositivos de **audio virtual (PipeWire)** , haciendo el proceso transparente para los participantes.

### Diagrama de Flujo (Mermaid)

```mermaid
flowchart TD
    subgraph "Capa de Control (IaC)"
        A[Repositorio Git<br>Configuración Terraform] --> B[Terraform Apply]
        B --> C[Provisiona Nodo Principal]
        B --> D[Configura Nodo Failover<br>en Oracle Cloud]
    end

    subgraph "Operación Normal (On-Premise)"
        E[Raspberry Pi 5<br>Ubuntu Server + Docker] --> F[Modelo de IA<br>Voxtral/Latent Linguist]
        G[Aplicación de Llamada] -->|Audio| E
        E -->|Traducción + Voz| G
    end

    subgraph "Failover Automático"
        H[Health Check] -->|Si RPi no responde| I[Trigger Terraform]
        I --> J[Activar VM en OCI]
        J --> K[Redirigir Tráfico/Notificar]
    end

🏗️ Proposed Solution: Un Enfoque NetDevOps
El sistema sigue un pipeline completamente automatizado que gestiona todo el ciclo de vida del servidor de traducción:

Declarative Definition: La configuración del servidor (IP, paquetes, servicios) se define como código en Terraform y se almacena en GitHub.

Automated Provisioning: Al ejecutar terraform apply, Terraform se conecta por SSH a la Raspberry Pi y ejecuta los scripts de aprovisionamiento.

Initial Configuration: Cloud-init (usado en la instalación inicial) y los scripts de Terraform automatizan la configuración de hostname, usuarios, claves SSH y red.

Configuration Management: Scripts Bash y Python (invocados por Terraform) instalan y configuran Docker, PipeWire y todas las dependencias necesarias.

Real-Time Resilience: El sistema está diseñado para incluir health checks y un failover automático a Oracle Cloud, orquestado por el mismo Terraform, garantizando alta disponibilidad para el servicio de traducción.

🧰 Technology Stack
Categoría	Tecnologías
Infrastructure as Code (IaC)	Terraform, Cloud-init
Hardware & OS	Raspberry Pi 5 (8GB), Ubuntu Server 24.04 (ARM64)
Cloud Provider	Oracle Cloud Infrastructure (OCI) - Always Free (VM.Standard.A1.Flex, 4 OCPU ARM, 24GB RAM)
Containerization	Docker, Docker Compose
Audio & Streaming	PipeWire, WirePlumber, PulseAudio (pactl)
CI/CD & Version Control	Git, GitHub
Programming & Scripting	Bash, Python 3, HCL (Terraform)
AI Models (Planned)	Mistral Voxtral (Realtime), Latent Linguist (Offline)
Monitoring (Planned)	Prometheus, Grafana
Security	SSH (key-based), IP fija, segmentación de red

🗂️ Repository Structure
traductor-ia-terraform/
├── terraform/
│   ├── main.tf                 # Recurso null_resource y provisioners
│   ├── variables.tf             # Definición de variables (IP, usuario, key)
│   ├── outputs.tf               # Outputs de la ejecución
│   └── terraform.tfvars.example # Plantilla para variables sensibles
├── scripts/
│   ├── setup-audio.sh           # Configuración de PipeWire y dispositivos virtuales
│   └── deploy-model.sh          # Script para desplegar el contenedor del modelo (WIP)
├── docs/
│   ├── diagrama-architectura.png (opcional)
│   └── troubleshooting.md       # Problemas comunes y soluciones
├── .gitignore                   # Ignorar terraform.tfvars, .terraform, etc.
├── LICENSE                      # MIT License
└── README.md                    # Este archivo

🚀 Cómo Reproducirlo (Hasta la Fase de IaC)
Prerrequisitos
Raspberry Pi 5 con Ubuntu Server 24.04 instalado y conectada a la red.

PC con Windows/Linux/macOS y Terraform instalado.

Clave SSH configurada para acceso sin contraseña a la Raspberry.

Pasos Rápidos
Clona el repositorio:

bash
git clone https://github.com/FerLepez1/traductor-ia-terraform.git
cd traductor-ia-terraform/terraform
Configura tus variables:

bash
cp terraform.tfvars.example terraform.tfvars
# Edita terraform.tfvars con la IP de tu Raspberry y la ruta a tu clave SSH privada
Inicia y Aplica:

bash
terraform init
terraform plan
terraform apply -auto-approve
Verifica la conexión:

bash
ssh tu-usuario@IP-de-tu-raspberry
docker --version
pactl info
📊 Lecciones Aprendidas y Desafíos Técnicos (Key Takeaways)
Infraestructura Híbrida Real: Implementar un sistema que combina un dispositivo Edge con un failover en la nube usando una sola herramienta (Terraform) es no solo posible, sino eficiente y mantenible.

Gestión de Estado y Conectividad: El principal desafío no fue Terraform en sí, sino la orquestación de redes: IPs dinámicas, resolución de nombres (mDNS en Windows vs. Linux) y diagnósticos de conectividad. Este proyecto demuestra una capacidad sólida para resolver problemas de red del mundo real.

Hardware Real, Problemas Reales: La experiencia con el driver WiFi de la Raspberry Pi 5 (error -52) subraya la importancia de la estabilidad del medio físico. La solución (migrar a Ethernet) es una decisión de arquitectura madura.

El Audio es Complejo pero Gobernable: Configurar un stack de audio moderno (PipeWire) de forma headless y automatizada fue un desafío, pero resultó en un sistema de inyección de audio extremadamente flexible y desacoplado de las aplicaciones.

🚀 Key Takeaways & Skills Demonstrated
Arquitectura de Sistemas Híbridos (Edge/Cloud): Capacidad para diseñar e implementar soluciones que integran hardware de punta (Raspberry Pi) con infraestructura en la nube (Oracle Cloud) para crear sistemas resilientes y distribuidos, aplicando patrones de alta disponibilidad como el failover automático.

Infraestructura como Código (IaC) Profesional: Dominio de Terraform no solo para aprovisionar, sino para orquestar configuraciones complejas en entornos híbridos, incluyendo la gestión de scripts de post-aprovisionamiento (Bash) y la resolución de problemas de conectividad y estado en sistemas reales.

Integración de Tecnologías de Bajo Nivel con IA: Experiencia práctica en la configuración de stacks de audio de baja latencia (PipeWire) en Linux embebido, preparando el terreno para la integración de modelos de IA de última generación (como Voxtral), demostrando una visión integral desde el hardware hasta la aplicación.

Metodología de Trabajo y Resolución de Problemas: Aplicación de un enfoque estructurado (GitOps, documentación por fases) para abordar desafíos técnicos concretos (problemas de drivers WiFi, DHCP, resolución de nombres), documentando el proceso y las soluciones, una habilidad crucial para entornos SRE/Platform Engineering.

🔗 Conecta Conmigo
Estoy activamente buscando oportunidades como Ingeniero de Plataforma (Platform Engineer), DevOps Senior o Líder de Infraestructura Linux en equipos remotos internacionales.

LinkedIn: linkedin.com/in/fernandolepezruiz

Email: fernando.lepezruiz@gmail.com

GitHub: github.com/FerLepez1

Otros Proyectos: Tesis - Replicación Proxmox en Hospital

⭐ Si este proyecto te resulta útil o interesante, ¡no olvides dejar una estrella! ⭐