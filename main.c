// ==========================================
// RISC-V M-EXTENSION STRESS TEST (HARVARD FIX)
// ==========================================

int compute_factorial(int n) {
    int result = 1;
    for (int i = 1; i <= n; i++) {
        result = result * i; 
    }
    return result;
}

int compute_gcd(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;           
        a = temp;
    }
    return a;
}

int main() {
    // THE HARVARD FIX:
    // By assigning these explicitly, the compiler uses CPU instructions 
    // to build the array in Data RAM at runtime!
    int data[5];
    data[0] = 120;
    data[1] = 45;
    data[2] = 28;
    data[3] = 7;
    data[4] = 14;
    
    int n = 5;
    int total_acc = 0;

    for (int i = 0; i < n - 1; i++) {
        int scaled_val = data[i] / 15; 
        int fact = compute_factorial(scaled_val); 
        int gcd = compute_gcd(data[i], data[i+1]);
        int lcm = (data[i] * data[i+1]) / gcd; 

        total_acc += (fact + lcm);
    }

    return total_acc;
}






// int main() {
//     int a = 0;
//     int b = 1;
//     int iterations = 9;

//     while (iterations != 0) {
//         int next_fib = a + b;
//         a = b;
//         b = next_fib;
//         iterations = iterations - 1;
//     }

//     // Since we have no screen, we just return the answer.
//     // The compiler will automatically put this final value into register x10.
//     return b; 
// }
// int main() {
//     // Write 'G' (Hex 47) directly to address 0x1000
//     *((volatile char *)0x1000) = 'G';
    
//     // Write 'O' (Hex 4F) directly to address 0x1000
//     *((volatile char *)0x1000) = 'O';

//     return 15;
// }





