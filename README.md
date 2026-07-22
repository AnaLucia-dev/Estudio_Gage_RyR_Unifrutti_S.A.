# 🥑 Evaluación y Estudio de la Capacidad del Sistema de Medición (MSA) – Unifrutti S.A.

<div align="center">

# 🥑 Measurement System Analysis (MSA)

**Evaluación de la capacidad del sistema de medición para el proceso de recepción de palta Hass (Calibre 20)**

![R](https://img.shields.io/badge/R-4.6.0-276DC3?style=for-the-badge&logo=r)
![Minitab](https://img.shields.io/badge/Minitab-ANOVA-orange?style=for-the-badge)
![Statgraphics](https://img.shields.io/badge/Statgraphics-Centurion-green?style=for-the-badge)
![Excel](https://img.shields.io/badge/Microsoft-Excel-217346?style=for-the-badge&logo=microsoft-excel)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

**Universidad Nacional de Piura**  
**Escuela Profesional de Estadística**

*Repositorio oficial del estudio de capacidad del sistema de medición (MSA) aplicado al proceso de recepción de palta Hass en Unifrutti S.A.*

</div>

---

# 📖 Descripción del Proyecto

Este proyecto desarrolla la **Evaluación de la Capacidad del Sistema de Medición (Measurement System Analysis, MSA)** aplicado a la gramera electrónica utilizada durante la recepción de **palta Hass (Calibre 20)** en la empresa agroexportadora **Unifrutti S.A.**, Planta Rapel (Piura, Perú).

El propósito principal consiste en determinar si el sistema de medición es capaz de proporcionar mediciones confiables, repetibles, reproducibles y suficientemente precisas para ser utilizado en el control estadístico del proceso.

La investigación se desarrolló siguiendo rigurosamente las recomendaciones del manual:

> **Measurement Systems Analysis (MSA), Fourth Edition**  
> Automotive Industry Action Group (AIAG, 2010).

---

# 🎯 Objetivos

## Objetivo General

Evaluar la capacidad del sistema de medición empleado para determinar el peso de la palta Hass mediante estudios de exactitud, linealidad y Gage R&R.

## Objetivos Específicos

- Evaluar el sesgo (Bias) del sistema de medición.
- Analizar la linealidad del equipo en todo el rango operativo.
- Determinar la repetibilidad y reproducibilidad mediante Gage R&R.
- Cuantificar los componentes de variación utilizando ANOVA.
- Calcular el Número de Categorías Distintas (NDC).
- Verificar la capacidad del sistema para su utilización en procesos de control estadístico.

---

# 🏭 Empresa de Estudio

**Empresa:** Unifrutti S.A.

**Ubicación:** Planta Rapel – Piura, Perú

**Área evaluada:** Laboratorio de Control de Calidad

**Proceso:**

Recepción y clasificación de palta Hass destinada a exportación.

---

# 📚 Marco Normativo

El estudio fue desarrollado conforme a las recomendaciones internacionales de:

- AIAG MSA Manual (4th Edition)
- Automotive Industry Action Group
- ISO 22514
- ISO 5725
- Manuales de Control Estadístico de Procesos (SPC)

---

# 🧪 Estudios Realizados

## 1. Exactitud (Bias)

Se evaluó la diferencia entre el valor de referencia y el valor observado mediante múltiples mediciones sobre patrones certificados.

Se estimó:

- Sesgo promedio
- Error porcentual
- Intervalos de confianza
- Prueba t para sesgo

---

## 2. Linealidad

Se analizó si el sesgo permanece constante a lo largo del rango de medición.

Se empleó:

- Regresión lineal
- ANOVA
- Intervalos de confianza
- Prueba de pendiente

---

## 3. Gage R&R

Se evaluó la variación introducida por el sistema de medición mediante un diseño cruzado.

Componentes evaluados:

- Repetibilidad (Equipment Variation)
- Reproducibilidad (Appraiser Variation)
- Variación Parte a Parte
- Variación Total

Método utilizado:

- ANOVA de dos factores

---

# 💻 Software Utilizado

Para garantizar la reproducibilidad y la validación cruzada de resultados, el estudio empleó múltiples plataformas estadísticas.

| Software | Aplicación |
|-----------|------------|
| RStudio | Scripts, validación estadística y RMarkdown |
| Minitab | Gage R&R, ANOVA y gráficos |
| Statgraphics | Confirmación de resultados |
| Microsoft Excel | Organización y depuración de datos |

---

# 📁 Estructura del Repositorio

```text
MSA-Unifrutti/
│
├── datos/
│   ├── datos_palta.xlsx
│   └── paltas_linealidad.xlsx
│
├── scripts/
│   ├── analisis_MSA.Rmd
│   └── analisis_MSA.R
│
├── resultados/
│   ├── graficos/
│   ├── tablas/
│   └── reportes/
│
├── README.md
└── LICENSE
```

---

# 📊 Variables Analizadas

| Variable | Unidad |
|-----------|---------|
| Peso observado | gramos |
| Peso patrón | gramos |
| Operador | Factor |
| Pieza | Factor |
| Repetición | Factor |
| Sesgo | gramos |
| Error porcentual | % |

---

# 📈 Metodología Estadística

## Pruebas de Supuestos

Se verificó:

- Normalidad (Shapiro-Wilk)
- Normalidad (Kolmogorov-Smirnov)
- Homogeneidad de varianzas
- Independencia

---

## Modelos Estadísticos

- Regresión lineal
- ANOVA
- Componentes de varianza
- Método ANOVA para Gage R&R

---

## Indicadores Calculados

- Sesgo
- Exactitud
- Linealidad
- Repetibilidad
- Reproducibilidad
- %Study Variation
- %Tolerance
- NDC

---

# 📈 Principales Resultados

## ✅ Exactitud (Bias)

- Error porcentual: **0.40%**
- Cumple ampliamente el criterio AIAG (<10%)

---

## ✅ Linealidad

- Linealidad: **0.47%**
- Valor-p > 0.05
- El sesgo permanece constante entre **195 g y 222 g**

---

## ✅ Gage R&R (ANOVA)

- %Study Variation: **5.22%**

Clasificación:

**Sistema de medición excelente y completamente aceptable.**

---

## ✅ Número de Categorías Distintas

**NDC = 26**

Interpretación:

El sistema distingue con alta resolución diferencias pequeñas entre frutos, superando ampliamente el mínimo recomendado por AIAG (NDC ≥ 5).

---

# 📷 Resultados Gráficos

El repositorio incluye las siguientes salidas obtenidas en Minitab y RStudio:

- Gráfico de Componentes de Variación
- Gráfico R por Operador
- Gráfico X̄ por Operador
- Interacción Operador × Pieza
- Linealidad
- Regresión
- Histograma
- QQ Plot
- Residuos
- ANOVA
- Componentes de Varianza

---

# 📌 Conclusiones

- La balanza presentó un **error de exactitud de únicamente 0.40%**, muy inferior al límite recomendado por AIAG, evidenciando una excelente exactitud.

- El estudio de linealidad obtuvo un valor de **0.47%**, confirmando que el sesgo permanece constante a lo largo del rango operativo de medición.

- El estudio **Gage R&R mediante ANOVA** mostró que el sistema de medición consume solo el **5.22% de la variación total**, clasificándose como un sistema **excelente y completamente aceptable**.

- El **Número de Categorías Distintas (NDC = 26)** demuestra que el equipo posee una elevada capacidad discriminante para detectar pequeñas diferencias de peso entre frutos.

- En conjunto, los resultados confirman que la gramera electrónica utilizada en Unifrutti S.A. es adecuada para aplicaciones de control estadístico de procesos y cumple con las recomendaciones internacionales del manual MSA (AIAG).

---

# 📚 Referencias

Automotive Industry Action Group (AIAG). (2010). *Measurement Systems Analysis (MSA)* (4th ed.). AIAG.

Montgomery, D. C. (2020). *Introduction to Statistical Quality Control* (8th ed.). John Wiley & Sons.

Besterfield, D. H. (2018). *Quality Control* (9th ed.). Pearson.

ISO. (2019). *ISO 22514-7: Statistical methods in process management.*

ISO. (1994). *ISO 5725: Accuracy (Trueness and Precision) of Measurement Methods and Results.*

---

# 👩‍🔬 Equipo de Investigación

**Universidad Nacional de Piura**

**Escuela Profesional de Estadística**

## Integrantes

- Ana Lucía Facundo Villalta
- Viviana Estela Reyna Zavaleta
- Idaluz Román Mondragón
- Rosario del Pilar Timaná Castillo
- Milagros Marycarmen Tume More

**Docente**

Dr. César Leonardo Haro Díaz

**Curso**

Control Estadístico de Calidad II

**Año Académico**

2026

---

<div align="center">

### ⭐ Si este repositorio fue de utilidad para tus investigaciones, considera dejar una estrella.

**Measurement System Analysis (MSA) — Unifrutti S.A. — Universidad Nacional de Piura**

</div>
