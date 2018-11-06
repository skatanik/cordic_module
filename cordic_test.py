import math

print("Hello")

atan_table = []

iteration_number = 32

for i in range(0, iteration_number):
    val = math.atan(1 / (2 ** i)) / math.pi * 180
    atan_table.append(val)

print(atan_table)

input_angle_inp = -35
input_angle = input_angle_inp

ethalon_sin = math.sin(input_angle/180*math.pi)
ethalon_cos = math.cos(input_angle/180*math.pi)
print(ethalon_sin)
print(ethalon_cos)

x_old = 0.607
x_new = 0

y_old = 0
y_new = 0

s = 1

for i in range(0, iteration_number):
    if (input_angle >= 0):
        s = 1
    else:
        s = -1

    x_new = x_old - s * y_old / (2 ** i)
    y_new = y_old + s * x_old / (2 ** i)

    input_angle -= s * atan_table[i]
    x_old = x_new
    y_old = y_new

 #   print("Iteration " + str(i) + " x = " + str(x_new) + " y = " + str(y_new) + " angle = " + str(input_angle))

x_fin = x_new
y_fin = y_new

print("Sin cordic " + str(y_fin))
print("Cos cordic " + str(x_fin))

# Taylor func
sign = 1
summ = 0.0
summ_cos = 0.0
for i in range(0, iteration_number):
    summ = summ + sign * ((input_angle_inp*math.pi/180.0) ** (i*2 + 1)) / math.factorial(i*2 + 1)
    summ_cos = summ_cos + sign * ((input_angle_inp*math.pi/180.0) ** (i*2)) / math.factorial(i*2)
    sign = sign * (-1)

print(summ)
print(summ_cos)
