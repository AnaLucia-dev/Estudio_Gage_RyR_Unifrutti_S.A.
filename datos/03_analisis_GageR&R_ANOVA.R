# ==============================================================================
# SCRIPT 03: ESTUDIO GAGE R&R (MÉTODO ANOVA)
# Proyecto: Evaluación del Sistema de Medición en Unifrutti S.A.
# Archivo de entrada: datos_palta.xlsx
# ==============================================================================
rm(list = ls())
# Cargar librerías necesarias
library(readxl)
library(dplyr)

# --- PASO 1: IMPORTAR Y PREPARAR LOS DATOS ---
datos_rr <- read_excel("datos_palta.xlsx")

# Renombrar columnas para estandarizar
colnames(datos_rr) <- c("OrdenCorrida", "Parte", "Operador", "Medicion")

# Es VITAL convertir 'Parte' y 'Operador' a factores (variables categóricas) para el ANOVA
datos_rr$Parte <- as.factor(datos_rr$Parte)
datos_rr$Operador <- as.factor(datos_rr$Operador)

# Parámetros del diseño del estudio
p <- length(levels(datos_rr$Parte))     # Número de piezas (10)
o <- length(levels(datos_rr$Operador))  # Número de operadores (3)
r <- 3                                  # Número de repeticiones (ensayos)
Tolerancia <- 15                        # Banda de tolerancia (g)
K <- 6            # Estándar más reciente de la industria (AIAG 4ta Edición)


# --- PASO 2: ANOVA CON INTERACCIÓN ---
cat("\n--- TABLA ANOVA DE DOS FACTORES CON INTERACCIÓN ---\n")
anova_interaccion <- aov(Medicion ~ Parte + Operador + Parte:Operador, data = datos_rr)
resumen_interaccion <- summary(anova_interaccion)
print(resumen_interaccion)

# Extraer el valor-P de la interacción (Parte:Operador)
p_valor_int <- resumen_interaccion[[1]]["Parte:Operador", "Pr(>F)"]


# --- PASO 3: DECISIÓN SOBRE LA INTERACCIÓN Y ANOVA FINAL ---
# Si el valor-p de la interacción es mayor a 0.05, no es significativa y se consolida con el error (pooling)
if(p_valor_int > 0.05) {
  cat("\nEl valor-P de la interacción es", round(p_valor_int, 4), "> 0.05.\n")
  cat("Se consolida la interacción con el error (Modelo sin interacción).\n")
  
  anova_final <- aov(Medicion ~ Parte + Operador, data = datos_rr)
  
} else {
  cat("\nEl valor-P de la interacción es < 0.05. Se mantiene la interacción en el modelo.\n")
  anova_final <- anova_interaccion
}

cat("\n--- TABLA ANOVA FINAL UTILIZADA PARA LOS CÁLCULOS ---\n")
resumen_final <- summary(anova_final)
print(resumen_final)


# --- PASO 4: EXTRACCIÓN DE CUADRADOS MEDIOS (CM) ---
tabla_anova <- resumen_final[[1]]
CM_parte <- tabla_anova["Parte", "Mean Sq"]
CM_operador <- tabla_anova["Operador", "Mean Sq"]
CM_error <- tabla_anova["Residuals", "Mean Sq"]


# --- PASO 5: CÁLCULO DE COMPONENTES DE VARIANZA (VarComp) ---
# Fórmulas matemáticas estándar del Manual MSA (AIAG) para ANOVA sin interacción
Var_Repetibilidad <- CM_error
Var_Reproducibilidad <- max(0, (CM_operador - CM_error) / (p * r))
Var_Parte <- max(0, (CM_parte - CM_error) / (o * r))

# Varianzas agrupadas
Var_GRR <- Var_Repetibilidad + Var_Reproducibilidad
Var_Total <- Var_GRR + Var_Parte


# --- PASO 6: CÁLCULO DE DESVIACIONES ESTÁNDAR (SD) Y VARIACIÓN DEL ESTUDIO (6*SD) ---
SD_Repetibilidad <- sqrt(Var_Repetibilidad)
SD_Reproducibilidad <- sqrt(Var_Reproducibilidad)
SD_GRR <- sqrt(Var_GRR)
SD_Parte <- sqrt(Var_Parte)
SD_Total <- sqrt(Var_Total)

# Variación del Estudio (multiplicador = 6, según Minitab/MSA 4ta Edición)
VE_Repetibilidad <- K * SD_Repetibilidad
VE_Reproducibilidad <- K * SD_Reproducibilidad
VE_GRR <- K * SD_GRR
VE_Parte <- K * SD_Parte
VE_Total <- K * SD_Total


# --- PASO 7: CÁLCULO DE PORCENTAJES DE CONTRIBUCIÓN, ESTUDIO Y TOLERANCIA ---
# % Contribución (basado en la varianza)
Pct_Cont_Repet <- (Var_Repetibilidad / Var_Total) * 100
Pct_Cont_Reprod <- (Var_Reproducibilidad / Var_Total) * 100
Pct_Cont_GRR <- (Var_GRR / Var_Total) * 100
Pct_Cont_Parte <- (Var_Parte / Var_Total) * 100
Pct_Cont_Total <- (Var_Total / Var_Total) * 100

# % Variación del Estudio (%VE)
Pct_VE_Repet <- (VE_Repetibilidad / VE_Total) * 100
Pct_VE_Reprod <- (VE_Reproducibilidad / VE_Total) * 100
Pct_VE_GRR <- (VE_GRR / VE_Total) * 100
Pct_VE_Parte <- (VE_Parte / VE_Total) * 100
Pct_VE_Total <- (VE_Total / VE_Total) * 100

# % Tolerancia (P/T)
Pct_Tol_Repet <- (VE_Repetibilidad / Tolerancia) * 100
Pct_Tol_Reprod <- (VE_Reproducibilidad / Tolerancia) * 100
Pct_Tol_GRR <- (VE_GRR / Tolerancia) * 100
Pct_Tol_Parte <- (VE_Parte / Tolerancia) * 100
Pct_Tol_Total <- (VE_Total / Tolerancia) * 100

# --- PASO 8: NÚMERO DE CATEGORÍAS DISTINTAS (NDC) ---
# Fórmula: 1.41 * (Sigma_Parte / Sigma_GRR), truncado al entero menor
NDC <- floor(1.41 * (SD_Parte / SD_GRR))


# 9. Construir el Data Frame con la estructura visual exacta
Tabla_Reporte <- data.frame(
  Fuente_de_variacion = c("Total R&R", "  Repetibilidad", "  Reproducibilidad", "Parte", "Total"),
  Varianza = round(c(Var_GRR, Var_Repetibilidad, Var_Reproducibilidad, Var_Parte, Var_Total), 3),
  Desviacion_Estandar = round(c(SD_GRR, SD_Repetibilidad, SD_Reproducibilidad, SD_Parte, SD_Total), 3),
  Desv_Est_Multiplicada = round(c(VE_GRR, VE_Repetibilidad, VE_Reproducibilidad, VE_Parte, VE_Total), 3),
  Pct_de_variacion = round(c(Pct_VE_GRR, Pct_VE_Repet, Pct_VE_Reprod, Pct_VE_Parte, Pct_VE_Total), 2),
  Pct_de_Contribucion = round(c(Pct_Cont_GRR, Pct_Cont_Repet, Pct_Cont_Reprod, Pct_Cont_Parte, Pct_Cont_Total), 2),
  Pct_de_la_Tolerancia = round(c(Pct_Tol_GRR, Pct_Tol_Repet, Pct_Tol_Reprod, Pct_Tol_Parte, Pct_Tol_Total), 2)
)

# Renombrar columnas para que salgan exactamente igual a la imagen
nombre_mult <- paste(K, "Desviación Estándar")
names(Tabla_Reporte) <- c("Fuente de variación", "Varianza", "Desviación Estándar", 
                          nombre_mult, "% de variación", 
                          "% de Contribución (Varianzas)", "% de la Tolerancia")

# 10. Imprimir la Tabla 
cat("\n========================================================================================\n")
cat("      TABLA REPORTE DE REPETIBILIDAD Y REPRODUCIBILIDAD (Formato Manual Unidad 3) \n")
cat("========================================================================================\n")
print(Tabla_Reporte, row.names = FALSE)

# 11. Imprimir la fórmula del Número de Categorías Distintas (NDC)
nc <- 1.41 * (SD_Parte / SD_GRR)
cat("\n----------------------------------------------------------------------------------------\n")
cat("nc = 1.41 * (\u03C3_parte / \u03C3_R&R) = 1.41 * (", round(SD_Parte, 3), " / ", round(SD_GRR, 3), ") = ", floor(nc), "\n", sep="")
cat("----------------------------------------------------------------------------------------\n")
