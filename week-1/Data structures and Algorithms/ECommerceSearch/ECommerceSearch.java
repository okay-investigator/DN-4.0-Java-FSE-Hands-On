import java.util.*;

class Product {
    int productId;
    String productName;
    String category;

    public Product(int productId, String productName, String category) {
        this.productId = productId;
        this.productName = productName;
        this.category = category;
    }

    @Override
    public String toString() {
        return "ID: " + productId + ", Name: " + productName + ", Category: " + category;
    }
}


public class ECommerceSearch {
    static Scanner scanner = new Scanner(System.in);

    // Sample product list
    static Product[] products = {
        new Product(101, "Laptop", "Electronics"),
        new Product(205, "Shoes", "Fashion"),
        new Product(150, "Phone", "Electronics"),
        new Product(310, "Book", "Education"),
        new Product(120, "Headphones", "Electronics")
    };

    public static void main(String[] args) {
        Arrays.sort(products, Comparator.comparingInt(p -> p.productId)); 
        System.out.print("Enter Product ID to search: ");
        int targetId = scanner.nextInt();

        System.out.println("\nLinear Search:");
        linearSearch(targetId);

        System.out.println("\nBinary Search:");
        binarySearch(targetId);
    }

    
    static void linearSearch(int targetId) {
        for (Product p : products) {
            if (p.productId == targetId) {
                System.out.println("Product found: " + p);
                return;
            }
        }
        System.out.println("Product not found.");
    }

    
    static void binarySearch(int targetId) {
        int low = 0, high = products.length - 1;
        while (low <= high) {
            int mid = (low + high) / 2;
            if (products[mid].productId == targetId) {
                System.out.println("Product found: " + products[mid]);
                return;
            } else if (products[mid].productId < targetId) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        System.out.println("Product not found.");
    }
}
