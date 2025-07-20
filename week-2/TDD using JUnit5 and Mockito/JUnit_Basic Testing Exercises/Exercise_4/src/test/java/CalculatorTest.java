import org.junit.After;
import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

public class CalculatorTest {

    private Calculator calculator;

    @Before
    public void setUp() {
        calculator = new Calculator();
    }

    @After
    public void tearDown() {
        calculator = null;
    }

    @Test
    public void testAddition() {
        // Arrange
        int a = 5; int b = 3;
        // Act
        int result = calculator.add(a, b);
        // Assert
        assertEquals(8, result);
    }

    @Test
    public void testSubtraction() {
        // Arrange
        int a = 10; int b = 4;
        // Act
        int result = calculator.subtract(a, b);
        // Assert
        assertEquals(6, result);
    }
}
