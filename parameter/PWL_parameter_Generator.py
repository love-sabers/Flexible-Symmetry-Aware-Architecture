import numpy as np
import os
import matplotlib.pyplot as plt

def gelu(x):
    return 0.5 * x * (1 + np.tanh(np.sqrt(2 / np.pi) * (x + 0.044715 * x**3)))

def sin(x):
    return np.sin(x)

def float_to_fixed(val, int_bits, frac_bits):
    scale = 2 ** frac_bits
    max_val = 2 ** (int_bits + frac_bits - 1) - 1
    min_val = -2 ** (int_bits + frac_bits - 1)
    fixed = int(np.round(val * scale))
    fixed = max(min(fixed, max_val), min_val)
    return fixed

def to_hex(val, total_bits):
    if val < 0:
        val = (1 << total_bits) + val
    return format(val, f"0{(total_bits + 3) // 4}X")

def generate_pwl_constants(m: int, n: int, u: int, v: int, func=gelu, output_file=None, plot=False,
                            k_int_bits=4, k_frac_bits=12, b_int_bits=4, b_frac_bits=12):
    assert m + n == u + v, "要求 m + n == u + v"
    int_range = 2 ** u
    frac_range = 2 ** v
    frac_vals = np.linspace(0, 1, frac_range, endpoint=False)

    if output_file is None:
        func_name = func.__name__ if hasattr(func, '__name__') else 'custom'
        param_str = f"inputi{m}_inputf{n}_findLUT{u}_LinearCalc{v}_ki{k_int_bits}kf{k_frac_bits}bi{b_int_bits}bf{b_frac_bits}"
        output_file = f"parameter\\pwl_{func_name}_{param_str}.txt"

    hex_file = output_file.replace(".txt", ".hex")
    mem_file = output_file.replace(".txt", ".mem")

    if plot:
        full_x = []
        full_y = []
        full_y_pwl = []

    with open(output_file, 'w') as f_txt, open(hex_file, 'w') as f_hex, open(mem_file, 'w') as f_mem:
        f_txt.write("// Format: k_fixed b_fixed // k_float b_float\n")
        for i in range(int_range):
            x_vals = (i + frac_vals)/(2 ** (u - m))
            y_vals = func(x_vals)

            # Least squares fit to y = k * frac + b
            A = np.vstack([frac_vals, np.ones_like(frac_vals)]).T
            k, b = np.linalg.lstsq(A, y_vals, rcond=None)[0]

            k_fixed = float_to_fixed(k, k_int_bits, k_frac_bits)
            b_fixed = float_to_fixed(b, b_int_bits, b_frac_bits)

            k_hex = to_hex(k_fixed, k_int_bits + k_frac_bits)
            b_hex = to_hex(b_fixed, b_int_bits + b_frac_bits)

            f_txt.write(f"{k_fixed} {b_fixed} // {k:.10f} {b:.10f}\n")
            f_hex.write(f"{k_hex}{b_hex}\n")
            f_mem.write(f"{k_hex}{b_hex}\n")

            if plot:
                y_pwl = k * frac_vals + b
                full_x.extend(x_vals)
                full_y.extend(y_vals)
                full_y_pwl.extend(y_pwl)

    print(f"PWL parameters written to {output_file}, {hex_file}, and {mem_file}")

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
    # 示例：4位整数，4位小数，绘图开启，输出为定点格式 + hex格式 + mem格式
    generate_pwl_constants(m=2, n=10, u=8, v=4, func=gelu, plot=True, k_int_bits=4, k_frac_bits=12, b_int_bits=4, b_frac_bits=12)
