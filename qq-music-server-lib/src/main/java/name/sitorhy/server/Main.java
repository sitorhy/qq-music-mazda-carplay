package name.sitorhy.server;

public class Main
{
    public static void main(String[] args) throws Exception
    {
        ServerBoot boot = new ServerBoot(8080);
        boot.start();
    }
}