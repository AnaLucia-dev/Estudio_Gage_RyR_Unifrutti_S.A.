# ==============================================================================
# SCRIPT 02: ESTUDIO GAGE R&R (MÉTODO MEDIAS Y RANGOS)
# Proyecto: Evaluación del Sistema de Medición en Unifrutti S.A.
# Archivo de entrada: datos_palta.xlsx
# ==============================================================================
rm(list = ls())
# Cargar librerías necesarias
library(readxl)
library(dplyr)

# --- PASO 1: IMPORTAR LOS DATOS ---
datos_rr <- read_excel("datos_palta.xlsx")

# Renombrar las columnas para asegurar la compatibilidad del código
colnames(datos_rr) <- c("OrdenCorrida", "Parte", "Operador", "Medicion")

# Verificar la estructura y diseño balanceado (10 partes x 3 operadores x 3 ensayos)
cat("\n--- VERIFICACIÓN DEL DISEÑO BALANCEADO ---\n")
print(table(datos_rr$Parte, datos_rr$Operador))


# --- PASO 2: CÁLCULOS DE RANGOS Y MEDIAS ---
Rangos_medias <- datos_rr %>%
  group_by(Parte, Operador) %>%
  summarise(
    Rango = max(Medicion) - min(Medicion),
    Media = mean(Medicion),
    .groups = "drop"
  )


# --- PASO 3: REPETIBILIDAD (VARIACIÓN DEL EQUIPO - VE) ---
R_barra <- mean(Rangos_medias$Rango)
# ATENCIÓN: Como realizaste 3 repeticiones/ensayos, d2 = 1.693 (No 1.128 que es para 2)
d2 <- 1.693 
k1 <- 5.15 / d2
VE <- k1 * R_barra 
Sigma_repet <- VE / 5.15


# --- PASO 4: REPRODUCIBILIDAD (VARIACIÓN DEL OPERADOR - VO) ---
medias_operador <- datos_rr %>%
  group_by(Operador) %>%
  summarise(Media = mean(Medicion), .groups = "drop")

R_medias <- max(medias_operador$Media) - min(medias_operador$Media)
# Coeficiente d2* para 3 operadores:
d2_op <- 1.912 
k2 <- 5.15 / d2_op

p <- 10  # Número de piezas
r <- 3   # Número de repeticiones

VO <- sqrt(max(0, (k2 * R_medias)^2 - (VE^2 / (p * r))))
Sigma_reprod <- VO / 5.15


# --- PASO 5: ERROR DEL SISTEMA DE MEDICIÓN (GR&R) ---
GRR <- sqrt(VE^2 + VO^2)
Sigma_GRR <- GRR / 5.15


# --- PASO 6: VARIACIÓN PARTE A PARTE (VP) ---
medias_parte <- datos_rr %>%
  group_by(Parte) %>%
  summarise(Media = mean(Medicion), .groups = "drop")

Rango_parte <- max(medias_parte$Media) - min(medias_parte$Media)
# Coeficiente d2* para 10 partes:
d2_p <- 3.179
Sigma_partes <- Rango_parte / d2_p
VP <- 5.15 * Sigma_partes


# --- PASO 7: CÁLCULO DE LA VARIACIÓN TOTAL (VT) ---
Sigma_total <- sqrt(Sigma_partes^2 + Sigma_GRR^2)
VT <- 5.15 * Sigma_total


# --- PASO 8: PORCENTAJES DE VARIACIÓN SEGÚN LA TOLERANCIA (15g) ---
Tolerancia <- 15
V_VE  <- (VE / Tolerancia) * 100
V_VO  <- (VO / Tolerancia) * 100
V_GRR <- (GRR / Tolerancia) * 100
V_VP  <- (VP / Tolerancia) * 100


# --- PASO 9: NÚMERO DE CATEGORÍAS DISTINTAS (NDC) ---
NCD <- 1.41 * (Sigma_partes / Sigma_GRR)


# --- PASO 10: RESUMEN FINAL DE ESTADÍSTICOS ---
cat("\nRESULTADOS DEL GAGE R&R (MÉTODO MEDIAS Y RANGOS)\n")
cat("----------------------------------------------\n")
cat("VE (Repetibilidad) =", round(VE, 4), "\n")
cat("VO (Reproducibilidad) =", round(VO, 4), "\n")
cat("GRR (Error Medición) =", round(GRR, 4), "\n")
cat("VP (Variación Parte) =", round(VP, 4), "\n")
cat("VT (Variación Total) =", round(VT, 4), "\n\n")

cat("PORCENTAJES SEGÚN TOLERANCIA DE 15g\n")
cat("-----------------------------------\n")
cat("%GRR =", round(V_GRR, 2), "%\n")
cat("%VE  =", round(V_VE, 2), "%\n")
cat("%VO  =", round(V_VO, 2), "%\n")
cat("%VP  =", round(V_VP, 2), "%\n")
cat("NDC  =", round(NCD), "\n")


# ==============================================================================
# PASO 11: GRÁFICOS ESTÁNDAR AIAG
# ==============================================================================
par(mfrow=c(2,2)) # Configurar ventana para mostrar 4 gráficos principales juntos

# 1. Gráfico R por Operador
etiquetas <- paste(Rangos_medias$Parte, Rangos_medias$Operador, sep = "-")
plot(Rangos_medias$Rango, type="b", pch=19, col="blue", xaxt="n",
     xlab="Pieza - Operador", ylab="Rango", main="Gráfico R por Operador")
axis(1, at=1:nrow(Rangos_medias), labels=etiquetas, las=2, cex.axis=0.6)
abline(h=mean(Rangos_medias$Rango), col="red")

# 2. Gráfico de X_barra por operador
plot(medias_operador$Media, type="b", pch=19, col="red", xaxt="n",
     xlab="Operador", ylab="Media (g)", main="Gráfico X̄ por Operador")
axis(1, at=1:3, labels=c("A", "B", "C"))

# 3. Interacción Parte × Operador
interaction.plot(datos_rr$Parte, datos_rr$Operador, datos_rr$Medicion,
                 col=c("red","blue","green"), lwd=2, pch=19,
                 xlab="Parte (Palta)", ylab="Media (g)", 
                 main="Interacción Parte × Operador")

# 4. Componentes de Variación (% Tolerancia)
Porcentaje <- c(V_VE, V_VO, V_GRR, V_VP)
bp <- barplot(Porcentaje, names.arg=c("VE", "VO", "GRR", "VP"),
              col=c("orange", "gold", "red", "forestgreen"), ylim=c(0, 110),
              main="% Variación vs Tolerancia", ylab="Porcentaje (%)")
abline(h=10, lty=2, col="blue", lwd=2)
abline(h=30, lty=2, col="red", lwd=2)
text(bp, Porcentaje, round(Porcentaje, 1), pos=3)

# Volver a 1 gráfico por ventana para el NDC
par(mfrow=c(1,1)) 

# 5. Gráfico Número de Categorías Distintas (NDC)
barplot(NCD, names.arg="NDC", col="darkgreen", ylab="Categorías",
        ylim=c(0, max(5, NCD)*1.3), main="Número de Categorías Distintas")
abline(h=5, col="red", lwd=2, lty=2)
text(0.7, NCD, round(NCD, 1), pos=3)

