/** Login.java and Login.FXML made by Nicholas Que. 
 *  Login SQL and Validaiton collaborated by Stacy Rogers and Kim Lee.
 * Group Movie 2020. Modified 11/18 
 * 
 * **/
package application;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class Login {
	//Create a connection to the database		
	Connection con = null;
	//PRIVATE STRINGS
	private String passResults = null;;
	private String getEmail = null;
	private int getMemberID;
	private int getPaymentMethodsID;
	private String getFirstName = null;
	private String getLastName = null;
	private String getFullName = null;
	//BOOLEANS
	boolean userValid = false;
	boolean passValid = false;
	
	//TITLED AND ANCHOR PANE
    @FXML
    private AnchorPane anchorPane;    
    
    //BUTTONS
    @FXML
    private Button registerButton;
    @FXML
    private Button loginButton;
    @FXML
    private Button cancelQuitButton;
    @FXML
    private Button AboutUsButton;
    
    //TEXT FIELDS & PASSWORD FIELDS
    @FXML
    private TextField userNameField;
    @FXML
    private PasswordField passwordField;
    
    //LABELS
    @FXML
    private Label needAccountLabel;
    @FXML
    private Label passwordlabel;
    @FXML
    private Label welcomeLabel;
    @FXML
    private Label EmailLabel; 
    @FXML
    private Label captionLabel;
    @FXML
    private Label displayInvalid;
    @FXML
    private Label welcomeCaption;
        
    //METHOD FOR LOGIN ACCOUNT
    @FXML
    void loginAccount(ActionEvent event) throws SQLException, IOException { //Event Handler that logs user in upon clicking Enter. Code by Stacy Rogers and supported by Kim Lee.	
   
		 try {              
			 // registering Oracle driver class               
			 Class.forName("oracle.jdbc.driver.OracleDriver");               
			 
			 // getting connection               
			 con = DriverManager.getConnection( "jdbc:oracle:thin:@oracle.gulfcoast.edu:1539:CLASS",             
					 							"Java8311", "Java211");              
			 
			 //CREATE STRING FOR GETTING USERNAME(EMAIL) and PASSWORD
			 String GetUserName = userNameField.getText();		
			 String GetUserPass = passwordField.getText();
		
			 //RUNS SQL STATEMENT TO CHECK EMAIL AND PASSWORD - BASICALLY THIS IS VALIDATION AND CONFIRMATION.
			 Statement stmt = con.createStatement();
				try {
					String emailQuery = "SELECT last, first, email_address, member_id, payment_methods_id, password FROM mm_member "+
										"WHERE email_address = '" + GetUserName + "'" ;
					//System.out.println(emailQuery); Testing Purposes
					ResultSet email = stmt.executeQuery(emailQuery);	
					//Display the contents of the result set
					while(email.next()) {
						// System.out.println(email.getString("email_address")); Testing Purposes: Prints email.
						getEmail = email.getString("email_address");
						getMemberID = email.getInt("member_id");
						getFirstName = email.getString("first");
						getLastName = email.getString("last");
						getPaymentMethodsID = email.getInt("payment_methods_id");
						getFullName = getFirstName + " " + getLastName;
						userValid = true;
						// System.out.println(email.getString("password")); Testing Purposes: Prints password
						passResults = email.getString("password"); 
						}		
				}//end try
					catch(Exception e2) {			
					} //end catch
					//VALIDATES USERNAME: IF USER INPUT IS NOT EQUAL TO DATABASE EMAIL, DISPLAY INVALID	
				if (!(GetUserName.equals(getEmail))){
					displayInvalid.setText("Invalid Credentials");
					// System.out.println("Email user name Not correct."); Testing Purposes: Prints invalid email
					userValid = false;
				}
				
				//VALIDATES PASSWORD: IF USER INPUT IS EQUAL TO DATABASE EMAIL PASSWORD, DISPLAY VALID		
				if (GetUserPass.equals(passResults)) {			
					// System.out.println("Password validated"); Testing Purposes: Prints validated password
					passValid = true;	//SET BOOLEAN TO TRUE
				}
				
				//VALIDATES PASSWORD: IF USER INPUT IS NOT EQUAL TO DATABASE EMAIL PASS, DISPLAY INVALID
				else if (!GetUserPass.equals(getEmail)){
					displayInvalid.setText("Invalid Credentials");
					// System.out.println("Password Not correct."); Testing Purposes: Prints invalid password
					passValid = false;	
				}
				else {		
					displayInvalid.setText("Invalid Credentials");
					passValid = false;	
				}
				
		 } //End Try
		 catch (ClassNotFoundException e1) {        
			 e1.printStackTrace();        
			 }   
		 //end catch
		 finally{
			 try {
				 if(con!=null) con.close();	// close connection               
			 } catch (SQLException e1) {   
				 e1.printStackTrace();   
				 }//end catch     
		 }//end finally to close connection
		 
		 //WHEN ALL USER INFORMATION IS VALID, OPEN SELECTION MENU!
		 if (userValid == true && passValid == true) {
			 try {		
				 dataTransfer.setUser(getEmail);//sets EMAIL
				 //System.out.println(dataTransfer.getUser()); Testing Purposes
				 dataTransfer.setID(getMemberID);// sets MEMBER ID
				 //System.out.println(dataTransfer.getID()); Testing Purposes
				 dataTransfer.setName(getFullName); //sets FULL NAME
				 dataTransfer.setPaymentMethodsID(getPaymentMethodsID); //SETS PAYMENT METHODS ID
				 //System.out.println(dataTransfer.getPaymentMethodsID()); //TESTING PURPOSES

				 //LOADS SELECTION FXML, CLOSES LOGIN STAGE
				 VBox rootContainer = (VBox) FXMLLoader.load(getClass().getClassLoader().getResource("Selection.fxml"));	
				 Scene scene = new Scene(rootContainer);	
				 Stage primaryStage = new Stage();
				 primaryStage.getIcons().add(new Image("https://iconsplace.com/wp-content/uploads/_icons/ff0000/256/png/letter-r-icon-14-256.png"));
				 primaryStage.setTitle("Redflix: Selection");
				 primaryStage.setScene(scene);	
				 primaryStage.show();	
				 Stage stage = (Stage) loginButton.getScene().getWindow();	
				 stage.close();  	
			 } catch(Exception e) {	
				 e.printStackTrace();		
			 }	
		 }		 
		}//end ActionEvent
    
    //METHOD FOR QUITTING PROGRAM
    @FXML
    void quitProgram(ActionEvent event) { //action for quitting program. This will quit the program. Duh.
    	Platform.exit();
    }
    
    //METHOD FOR REGISTERING ACCOUNT
    @FXML
    void registerAccount(ActionEvent event) throws IOException { //action for registration. This will open Register.FXML
    		try {
    			Stage stage = (Stage) registerButton.getScene().getWindow();
    			stage.close();   			
    			VBox rootContainer = (VBox) FXMLLoader.load(getClass().getClassLoader().getResource("Register.fxml"));
    			Scene scene = new Scene(rootContainer);
    			Stage primaryStage = new Stage();
    			primaryStage.getIcons().add(new Image("https://iconsplace.com/wp-content/uploads/_icons/ff0000/256/png/letter-r-icon-14-256.png"));
    			primaryStage.setTitle("Redflix: Registration");
    			primaryStage.setScene(scene);
    			primaryStage.show();
    		} catch(Exception e) {
    			e.printStackTrace();
    		}
    }
 
    @FXML
    void displayAbout(ActionEvent event) {
    	try {
    		VBox rootContainer = (VBox) FXMLLoader.load(getClass().getClassLoader().getResource("AboutUs.fxml"));
			Scene scene = new Scene(rootContainer);
			Stage primaryStage = new Stage();
			primaryStage.getIcons().add(new Image("https://iconsplace.com/wp-content/uploads/_icons/ff0000/256/png/letter-r-icon-14-256.png"));
			primaryStage.setTitle("Redflix: About Us");
			primaryStage.setScene(scene);
			primaryStage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
    		
    	}    	
    }



