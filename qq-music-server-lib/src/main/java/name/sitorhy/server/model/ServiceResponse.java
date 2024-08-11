package name.sitorhy.server.model;

public class ServiceResponse<T> {
    private int code;
    private T data;
    private boolean success;
    private String message;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public ServiceResponse(String message, boolean success) {
        this.message = message;
        this.success = success;
    }

    public ServiceResponse(T data, boolean success) {
        this.data = data;
        this.success = success;
    }

    public ServiceResponse() {
        this.success = true;
    }
}
