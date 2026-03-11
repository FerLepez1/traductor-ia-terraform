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

## 🏗️ Proposed Solution: Un Enfoque NetDevOps

El sistema sigue un pipeline completamente automatizado que gestiona todo el ciclo de vida del servidor de traducción:

1.  **Declarative Definition:** La configuración del servidor (IP, paquetes, servicios) se define como código en **Terraform** y se almacena en GitHub.
2.  **Automated Provisioning:** Al ejecutar `terraform apply`, Terraform se conecta por SSH a la Raspberry Pi y ejecuta los scripts de aprovisionamiento.
3.  **Initial Configuration:** **Cloud-init** (usado en la instalación inicial) y los scripts de Terraform automatizan la configuración de hostname, usuarios, claves SSH y red.
4.  **Configuration Management:** **Scripts Bash y Python** (invocados por Terraform) instalan y configuran Docker, PipeWire y todas las dependencias necesarias.
5.  **Real-Time Resilience:** El sistema está diseñado para incluir **health checks** y un **failover automático** a Oracle Cloud, orquestado por el mismo Terraform, garantizando alta disponibilidad para el servicio de traducción.

## 🧰 Technology Stack

| Categoría | Tecnologías |
|:---|:---|
| **Infrastructure as Code (IaC)** | **Terraform**, Cloud-init |
| **Hardware & OS** | Raspberry Pi 5 (8GB), Ubuntu Server 24.04 (ARM64) |
| **Cloud Provider** | Oracle Cloud Infrastructure (OCI) - **Always Free** (VM.Standard.A1.Flex, 4 OCPU ARM, 24GB RAM) |
| **Containerization** | Docker, Docker Compose |
| **Audio & Streaming** | PipeWire, WirePlumber, PulseAudio (pactl) |
| **CI/CD & Version Control** | Git, GitHub |
| **Programming & Scripting** | Bash, Python 3, HCL (Terraform) |
| **AI Models (Planned)** | Mistral Voxtral (Realtime), Latent Linguist (Offline) |
| **Monitoring (Planned)** | Prometheus, Grafana |
| **Security** | SSH (key-based), IP fija, segmentación de red |

## 🗂️ Repository Structure

traductor-ia-terraform/
├── terraform/
│ ├── main.tf # Recurso null_resource y provisioners
│ ├── variables.tf # Definición de variables (IP, usuario, key)
│ ├── outputs.tf # Outputs de la ejecución
│ └── terraform.tfvars.example # Plantilla para variables sensibles
├── scripts/
│ ├── setup-audio.sh # Configuración de PipeWire y dispositivos virtuales
│ └── deploy-model.sh # Script para desplegar el contenedor del modelo (WIP)
├── docs/
│ ├── diagrama-architectura.png (opcional)
│ └── troubleshooting.md # Problemas comunes y soluciones
├── .gitignore # Ignorar terraform.tfvars, .terraform, etc.
├── LICENSE # MIT License
└── README.md # Este archivo


### **Sección 4: 🚀 Key Takeaways & Skills Demonstrated** 
```markdown
## 🚀 Key Takeaways & Skills Demonstrated

*   **Arquitectura e Implementación de Soluciones Complejas:** Diseño de un sistema híbrido (Edge + Cloud) con automatización completa y plan de recuperación ante desastres (failover).
*   **Integración de Stack Tecnológico Diverso:** Combinación exitosa de Terraform, Linux embebido (RPi), audio de baja latencia (PipeWire) y servicios cloud (OCI) en un sistema coherente.
*   **Aplicación de Prácticas DevOps (GitOps):** Uso de GitHub como fuente de verdad, commits atómicos y pipelines de IaC para garantizar reproducibilidad y control de versiones de la infraestructura.
*   **Resolución de Problemas del Mundo Real:** Diagnóstico y solución de desafíos concretos como IPs dinámicas (DHCP), resolución de nombres (mDNS) y estabilidad de drivers WiFi en hardware embebido.
*   **Visión de Futuro:** Preparación de la infraestructura para incorporar modelos de IA de última generación (Voxtral, <200ms de latencia) con preservación de voz, demostrando capacidad para adoptar tecnologías emergentes.
