package name.sitorhy.server.model;

public class TextServiceResponse extends ServiceResponse<String> {
    public TextServiceResponse() {}

    public TextServiceResponse(String response) {
        this.setData(response);
    }
}
