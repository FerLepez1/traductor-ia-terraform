# 🗣️ Traductor IA Tiempo Real con Raspberry Pi + Terraform

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Work in Progress](https://img.shields.io/badge/Status-Work%20in%20Progress-orange)]()
[![Terraform](https://img.shields.io/badge/Terraform-1.9.8-blue)](https://www.terraform.io)
[![Raspberry Pi](https://img.shields.io/badge/Raspberry%20Pi-5-red)](https://www.raspberrypi.com)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange)](https://ubuntu.com)
[![Docker](https://img.shields.io/badge/Docker-29.2.1-blue)](https://www.docker.com)
[![Oracle Cloud](https://img.shields.io/badge/Oracle%20Cloud-ARM%20Always%20Free-red)](https://www.oracle.com/cloud)

> **⚠️ PROYECTO EN DESARROLLO ACTIVO**  
> Este proyecto está siendo construido paso a paso. Las fases completadas están funcionando y documentadas. Las fases futuras están planificadas pero aún no implementadas.

## 📌 Descripción General

Arquitectura híbrida (on-premise + cloud) para traducción de voz en **tiempo real con preservación de tono y emociones**, diseñada para integrarse de forma transparente en cualquier plataforma de videollamadas (Zoom, Teams, Meet) sin necesidad de bots visibles.

**Objetivo final:** Lograr latencia <200ms con modelos S2ST modernos (Voxtral/Latent Linguist) y failover automático a la nube.

---

## 🏗️ Arquitectura del Proyecto

```mermaid
flowchart TD
    subgraph "On-Premise (Raspberry Pi 5)"
        A[RPi 5 - 8GB RAM<br>Ubuntu Server 24.04] --> B[Modelo Principal<br>Voxtral / Latent Linguist]
        C[PC con llamada<br>Zoom/Meet/Teams] -->|Audio loopback| A
        A -->|Traducción + voz clonada| C
    end
    
    subgraph "Cloud Backup (Oracle Cloud - Always Free)"
        D[VM.ARM - 4 OCPU, 24GB RAM] --> E[Modelo Backup]
        F[Health Check] -->|Si RPi falla| G[Terraform Apply]
        G -->|Activa| D
    end
    
    subgraph "Orquestación (Terraform)"
        H[main.tf] --> I[Provisiona RPi]
        H --> J[Configura OCI]
        H --> K[Monioreo]
    end