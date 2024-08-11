package name.sitorhy.server;

import name.sitorhy.server.model.ServiceResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Arrays;

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler
    @ResponseBody
    public ServiceResponse<String> exceptionHandler(Exception ex) {
        return new ServiceResponse<>(ex.getLocalizedMessage(), false);
    }
}
