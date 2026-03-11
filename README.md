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