\# 🗣️ Traductor IA Tiempo Real con Raspberry Pi + Terraform (WIP)



\[!\[License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

\[!\[Status: Work in Progress](https://img.shields.io/badge/Status-Work%20in%20Progress-orange)](https://github.com/FerLepez1/traductor-ia-terraform)



> \*\*⚠️ PROYECTO EN DESARROLLO ACTIVO\*\*  

> Este proyecto está siendo construido paso a paso. Las fases completadas están funcionando y documentadas. Las fases futuras están planificadas pero aún no implementadas.



\## 📌 Descripción General



Arquitectura híbrida (on-premise + cloud) para traducción de voz en \*\*tiempo real con preservación de tono y emociones\*\*, diseñada para integrarse de forma transparente en cualquier plataforma de videollamadas (Zoom, Teams, Meet) sin necesidad de bots visibles.



\*\*Objetivo final:\*\* Lograr latencia <200ms con modelos S2ST modernos (Voxtral/Latent Linguist) y failover automático a la nube.



\## 🏗️ Arquitectura del Proyecto



```mermaid

flowchart TD

&nbsp;   subgraph "On-Premise (Raspberry Pi 5)"

&nbsp;       A\[RPi 5 - 8GB RAM<br>Ubuntu Server] --> B\[Modelo Principal<br>Voxtral / Latent Linguist]

&nbsp;       C\[PC con llamada<br>Zoom/Meet/Teams] -->|Audio loopback| A

&nbsp;       A -->|Traducción + voz clonada| C

&nbsp;   end

&nbsp;   

&nbsp;   subgraph "Cloud Backup (Oracle Cloud - Always Free)"

&nbsp;       D\[VM.ARM - 4 OCPU, 24GB RAM] --> E\[Modelo Backup]

&nbsp;       F\[Health Check] -->|Si RPi falla| G\[Terraform Apply]

&nbsp;       G -->|Activa| D

&nbsp;   end

&nbsp;   

&nbsp;   subgraph "Orquestación (Terraform)"

&nbsp;       H\[main.tf] --> I\[Provisiona RPi]

&nbsp;       H --> J\[Configura OCI]

&nbsp;       H --> K\[Monioreo]

&nbsp;   end

