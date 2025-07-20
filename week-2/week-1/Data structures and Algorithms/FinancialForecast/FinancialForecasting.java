public class FinancialForecasting {

    
    public static double forecastRecursive(int year, double currentValue, double growthRate) {
        if (year == 0) {
            return currentValue;
        }
        return forecastRecursive(year - 1, currentValue, growthRate) * (1 + growthRate);
    }

    
    public static double forecastIterative(int year, double currentValue, double growthRate) {
        double futureValue = currentValue;
        for (int i = 0; i < year; i++) {
            futureValue *= (1 + growthRate);
        }
        return futureValue;
    }

    public static void main(String[] args) {
        // Sample values
        double initialValue = 10000;         
        double annualGrowthRate = 0.08;      
        int years = 5;                       

       
        double recursiveResult = forecastRecursive(years, initialValue, annualGrowthRate);
        System.out.printf("Recursive Forecast (after %d years): %.2f\n", years, recursiveResult);

        
        double iterativeResult = forecastIterative(years, initialValue, annualGrowthRate);
        System.out.printf("Iterative Forecast (after %d years): %.2f\n", years, iterativeResult);
    }
}
