package name.sitorhy.server;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.util.resource.Resource;
import org.eclipse.jetty.ee10.webapp.WebAppContext;
import org.eclipse.jetty.util.resource.ResourceFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main
{
    private static final Logger LOG = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws Exception
    {
        int port = 8080;
        Server server = newServer(port);
        server.start();
        server.join();

    }

    public static Server newServer(int port) {
        Server server = new Server(port);

        WebAppContext context = new WebAppContext();
        Resource baseResource = findBaseResource(context);
        LOG.info("Using BaseResource: {}", baseResource);
        context.setBaseResource(baseResource);
        context.setContextPath("/");
        context.setParentLoaderPriority(true);
        server.setHandler(context);

        return server;
    }

    private static Resource findBaseResource(WebAppContext context)
    {
        ResourceFactory resourceFactory = ResourceFactory.of(context);

        try
        {
            ClassLoader classLoader = context.getClass().getClassLoader();
            URL webXml = classLoader.getResource("WEB-INF/web.xml");
            if (webXml != null)
            {
                URI uri = webXml.toURI().resolve("../").normalize();
                LOG.info("Found WebResourceBase (Using ClassLoader reference) {}", uri);
                return resourceFactory.newResource(uri);
            }
        }
        catch (URISyntaxException e)
        {
            throw new RuntimeException("Bad ClassPath reference for: WEB-INF", e);
        }

        throw new RuntimeException("Unable to find web resource ref");
    }
}