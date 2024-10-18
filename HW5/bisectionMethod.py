def f(x):
    return x**3 - 4*x**2 - 8*x + 30

def bisection(a, b, tol):
    if f(a) * f(b) >= 0:
        print("The bisection method cannot be applied.")
        return None, None

    iteration = 0
    while (b - a) / 2 > tol:
        c = (a + b) / 2
        if f(c) == 0:
            # Found exact root
            return c, iteration
        elif f(a) * f(c) < 0:
            b = c
        else:
            a = c
        iteration += 1

    # Midpoint is our approximation of the root
    c = (a + b) / 2
    return c, iteration

# Initial interval and tolerance
a = 2
b = 4
tolerance = 1e-6

# Run the bisection method
root, steps = bisection(a, b, tolerance)

if root is not None:
    # Convert the root to the form N / 2^k
    N = int(root * (2 ** steps))
    k = steps
    print(f"Number of steps: {steps}")
    print(f"Root as a fraction: {N}/2^{k}")
    print(f"Approximate root: {root}")
