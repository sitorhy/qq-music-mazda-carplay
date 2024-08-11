package name.sitorhy.server;

import name.sitorhy.server.model.ServiceResponse;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.Arrays;

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler
    @ResponseBody
    public ServiceResponse<String> exceptionHandler(Exception ex){
        ServiceResponse<String> response = new ServiceResponse<>(ex.getLocalizedMessage(), false);
        response.setCode(500);
        return response;
    }

    @ExceptionHandler
    @ResponseBody
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ServiceResponse<String> notFoundHandler(NoHandlerFoundException ex){
        ServiceResponse<String> response = new ServiceResponse<>(ex.getLocalizedMessage(), false);
        response.setCode(404);
        return response;
    }
}
