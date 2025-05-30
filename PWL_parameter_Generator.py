import numpy as np
import os
import matplotlib.pyplot as plt
from datetime import datetime

def gelu(x):
    return 0.5 * x * (1 + np.tanh(np.sqrt(2 / np.pi) * (x + 0.044715 * x**3)))

def sin(x):
    return np.sin(x)

def generate_pwl_constants(m: int, n: int, u: int, v: int, func=gelu, output_file=None, plot=False):
    assert m + n == u + v, "要求 m + n == u + v"
    int_range = 2 ** u
    frac_range = 2 ** v
    frac_vals = np.linspace(0, 1, frac_range, endpoint=False)

    if output_file is None:
        func_name = func.__name__ if hasattr(func, '__name__') else 'custom'
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_file = f"pwl_params_{func_name}_{timestamp}.txt"

    if plot:
        full_x = []
        full_y = []
        full_y_pwl = []

    with open(output_file, 'w') as f:
        f.write("// Format: k b\n")
        for i in range(int_range):
            x_vals = (i + frac_vals)/(2 ** (u - m))
            y_vals = func(x_vals)

            # Least squares fit to y = k * frac + b
            A = np.vstack([frac_vals, np.ones_like(frac_vals)]).T
            k, b = np.linalg.lstsq(A, y_vals, rcond=None)[0]

            f.write(f"{k:.10f} {b:.10f}\n")

            if plot:
                y_pwl = k * frac_vals + b
                full_x.extend(x_vals)
                full_y.extend(y_vals)
                full_y_pwl.extend(y_pwl)

    print(f"PWL parameters written to {output_file}")

    if plot:
        # 绘图
        plt.figure(figsize=(10, 6))
        plt.plot(full_x, full_y, label="Original Function", linewidth=2)
        plt.plot(full_x, full_y_pwl, label="PWL Approximation", linestyle="--")
        plt.title("Function vs PWL Approximation")
        plt.xlabel("x")
        plt.ylabel("y")
        plt.legend()
        plt.grid(True)
        plt.tight_layout()
        plt.show()

if __name__ == "__main__":
    # 示例：4位整数，4位小数，绘图开启
    generate_pwl_constants(m=4, n=8, u=8, v=4, func=sin, plot=True)
