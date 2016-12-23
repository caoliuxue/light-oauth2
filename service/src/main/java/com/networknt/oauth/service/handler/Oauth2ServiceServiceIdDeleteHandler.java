package com.networknt.oauth.service.handler;

import com.networknt.oauth.service.PathHandlerProvider;
import com.networknt.service.SingletonServiceFactory;
import com.networknt.status.Status;
import io.undertow.server.HttpHandler;
import io.undertow.server.HttpServerExchange;
import io.undertow.util.HttpString;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import org.apache.commons.lang3.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.sql.DataSource;

public class Oauth2ServiceServiceIdDeleteHandler implements HttpHandler {
    static String SERVICE_NOT_FOUND = "ERR12015";
    static Logger logger = LoggerFactory.getLogger(Oauth2ServiceServiceIdGetHandler.class);
    static DataSource ds = (DataSource) SingletonServiceFactory.getBean(DataSource.class);
    static String sql = "DELETE FROM services WHERE service_id = ?";

    public void handleRequest(HttpServerExchange exchange) throws Exception {
        String serviceId = exchange.getQueryParameters().get("serviceId").getFirst();
        try (Connection connection = ds.getConnection(); PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, serviceId);
            int count = stmt.executeUpdate();
            if(count == 1) {
                PathHandlerProvider.services.remove(serviceId);

            } else {
                Status status = new Status(SERVICE_NOT_FOUND, serviceId);
                exchange.setStatusCode(status.getStatusCode());
                exchange.getResponseSender().send(status.toString());
                return;
            }
        } catch (SQLException e) {
            logger.error("Exception:", e);
            // should handle this exception and return an error message.
            throw e;
        }
    }
}
