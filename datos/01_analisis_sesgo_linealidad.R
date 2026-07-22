# ==============================================================================
# SCRIPT 01: ANÁLISIS DE EXACTITUD (SESGO) Y LINEALIDAD
# Proyecto: Evaluación del Sistema de Medición en Unifrutti S.A.
# Archivo de entrada: paltas_linealidad.xlsx
# ==============================================================================
rm(list = ls())
# Cargar librerías necesarias
library(readxl)

# --- PASO 1: IMPORTAR LOS DATOS ---
# Asegúrate de que el archivo Excel esté en el mismo directorio de trabajo (Working Directory)
datos_linealidad <- read_excel("paltas_linealidad.xlsx")

# Mostrar las primeras filas para confirmar la carga exitosa
head(datos_linealidad)


# ==============================================================================
# ESTUDIO DE EXACTITUD (SESGO) - NIVEL BÁSICO (R BASE)
# ==============================================================================
# Para el sesgo, evaluamos la Pieza Master con valor de referencia = 210g
datos_sesgo <- subset(datos_linealidad, Valor_Master == 210)
mediciones_sesgo <- datos_sesgo$Peso
valor_referencia <- 210

# --- Prueba de Normalidad (Shapiro-Wilk) ---
cat("\n--- PRUEBA DE NORMALIDAD (PIEZA MASTER 210g) ---\n")
print(shapiro.test(mediciones_sesgo))

# --- Cálculo del Sesgo ---
promedio_medido <- mean(mediciones_sesgo)
sesgo_promedio <- promedio_medido - valor_referencia
sesgo_promedio

# --- Prueba de Hipótesis (T-Test) ---
# H0: El sesgo es igual a 0 (El instrumento es exacto)
# H1: El sesgo es diferente de 0
resultado_test <- t.test(mediciones_sesgo, mu = valor_referencia)
print(resultado_test)

# --- Intervalo de confianza para el sesgo ---
IC <- resultado_test$conf.int - valor_referencia

# --- Resumen de Sesgo ---
cat("\nRESULTADOS DE EXACTITUD (SESGO)\n")
cat("-------------------------------\n")
cat("Sesgo =", round(sesgo_promedio, 4), "g\n")
cat("IC 95% del sesgo: [", round(IC[1], 4), ",", round(IC[2], 4), "]\n")

# --- Gráfico de Sesgo ---
boxplot(mediciones_sesgo, 
        main = "Análisis de Exactitud (Sesgo) - Master 210g", 
        ylab = "Mediciones de Peso (g)", col = "lightblue")
abline(h = valor_referencia, col = "red", lwd = 2, lty = 2)
legend("topright", legend = c("Valor de Referencia"), col = c("red"), lty = 2, lwd = 2)


# ==============================================================================
# ESTUDIO DE LINEALIDAD 
# ==============================================================================

# --- Calcular el Sesgo (Bias) general para cada lectura ---
datos_linealidad$Sesgo <- datos_linealidad$Peso - datos_linealidad$Valor_Master

# --- Crear el modelo de regresión lineal (Sesgo en función de la Referencia) ---
modelo_linealidad <- lm(Sesgo ~ Valor_Master, data = datos_linealidad)

# --- Mostrar los resultados estadísticos ---
cat("\n--- RESULTADOS DEL MODELO DE LINEALIDAD ---\n")
print(summary(modelo_linealidad))

# --- Mostrar los Intervalos de confianza de los coeficientes ---
cat("\n--- INTERVALOS DE CONFIANZA (MODELO DE LINEALIDAD) ---\n")
print(confint(modelo_linealidad))

# --- Generar el Gráfico de Linealidad (Estándar AIAG) ---
plot(datos_linealidad$Valor_Master, datos_linealidad$Sesgo, 
     main = "Estudio de Linealidad de la Gramera Electrónica",
     xlab = "Valor de Referencia (Master) [g]", 
     ylab = "Sesgo (Bias) [g]", 
     pch = 19, col = "blue")

# Añadir línea de regresión (roja) y línea de sesgo cero (negra discontinua)
abline(modelo_linealidad, col = "red", lwd = 2)
abline(h = 0, col = "black", lty = 2)

