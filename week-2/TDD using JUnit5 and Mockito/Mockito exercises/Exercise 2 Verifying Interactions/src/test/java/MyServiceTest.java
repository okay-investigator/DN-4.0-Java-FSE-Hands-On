import static org.mockito.Mockito.*;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

public class MyServiceTest {
    @Test
    public void testVerifyInteraction() {
        // Create a mock object
        ExternalApi mockApi = Mockito.mock(ExternalApi.class);

        // Pass the mock to the service
        MyService service = new MyService(mockApi);

        // Call the method under test
        service.fetchData();

        // Verify interaction: that getData() was called
        verify(mockApi).getData();
    }
}
