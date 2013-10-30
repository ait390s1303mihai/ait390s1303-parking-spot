/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Mihai Boicu
 */

package parkingspot.gae.servlet;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * The Filter to check and redirect parking spot administrative login.
 *
 */
public class AdminLoginFilter implements Filter {
  
	/**
	 * The filter configuration.
	 */
    private FilterConfig filterConfig;

    /**
     * Process the filter request. If an admin is not logged redirect the request to the login page.
     * If the user has no rights for the operation report invalid access. 
     */
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain)
        throws IOException, ServletException {
    	//check if it is in a current session with the client
    	
    	
    	

        filterChain.doFilter(request, response);
    }

    /**
     * Return the current filter configuration.
     * @return a FilterConfig with the configuration.
     */
    public FilterConfig getFilterConfig() {
        return filterConfig;
    }

    /**
     * Initialize the current filter configuration.
     */
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }
  
    /**
     * Destroy the filter.
     */
    public void destroy() {}
  
}