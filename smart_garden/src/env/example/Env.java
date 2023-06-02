package example;

import jason.asSyntax.*;
import jason.environment.*;
import java.util.logging.*;
import java.util.Random;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.Condition;

import javax.swing.*;
import javax.swing.border.Border;
import java.awt.*;
import java.text.DecimalFormat;

public class Env extends Environment {
	/** Called before the MAS execution with the args informed in .mas2j */
	private final int gardenSize = 10;
	private final int paramSize = 4;
	private double[][][] garden = new double[gardenSize][gardenSize][paramSize]; // 0: plant growth, 1: water, 2:
																					// nutrients, 3: pests
	private int pestTypes = 3;
	private Random rand = new Random();
	private ArrayGridDisplay gui;
	private Logger logger = Logger.getLogger("smart_garden.mas2j." + Env.class.getName());
	Literal belief;

	private int countervote = 0;
	private int[] votesIrrigation = new int[]{0,0,0};
	private int[] votesFertilization = new int[]{0,0,0};
	private int[] votesSparying = new int[]{0,0,0};

	private boolean lefutott=true;
	private static Lock lock = new ReentrantLock();
	private static Condition condition = lock.newCondition();
	private static boolean shouldSignal = false;

	public double getAverageParam(int param) {
		double sum = 0;
		for (int i = 0; i < gardenSize; i++) {
			for (int j = 0; j < gardenSize; j++) {
				sum += garden[i][j][param];
			}
		}
		return sum / (gardenSize * gardenSize);
	}

	@Override
	public void init(String[] args) {
		// initialize garden
		for (int i = 0; i < gardenSize; i++) {
			for (int j = 0; j < gardenSize; j++) {
				for (int k = 0; k < paramSize; k++) {
					if (k == 3) {
						garden[i][j][k] = 0;
						continue;
					}
					garden[i][j][k] = rand.nextDouble();
				}
			}
		}
		gui = new ArrayGridDisplay();

		belief = Literal.parseLiteral("growth(" + getAverageParam(0) + ")");
		addPercept("monitor", belief);
		belief = Literal.parseLiteral("water(" + getAverageParam(1) + ")");
		addPercept("irrigator", belief);
		belief = Literal.parseLiteral("fertilizer(" + getAverageParam(2) + ")");
		addPercept("fertilizer", belief);
		belief = Literal.parseLiteral("pests(" + getpests() + ")");
		addPercept("pestcontrol", belief);

	}

	public void water(int ind){
		double amount=0;
		if(ind==1){
			amount=0.05;
		}
		if(ind==2){
			amount=0.1;
		}
		for (int i = 0; i < gardenSize; i++) {
			for (int j = 0; j < gardenSize; j++) {
				garden[i][j][1] = Math.min(Math.max(garden[i][j][1] + amount, 0), 1);
			}
		}
	}

	public void fertilize(int ind){
		double fertamount=0;
		if(ind==1){
			fertamount=0.09;
		}
		if(ind==2){
			fertamount=0.18;
		}
		for (int i = 0; i < gardenSize; i++) {
			for (int j = 0; j < gardenSize; j++) {
				garden[i][j][2] = Math.min(Math.max(garden[i][j][2] + fertamount, 0), 1);
			}
		}
	}

	public void spray(int type){
		for (int i = 0; i < gardenSize; i++) {
			for (int j = 0; j < gardenSize; j++) {
				//type 1 spray kills 80% of pest1 and 50% of pest2, but also reduces growth by 30%
				if(type == 1){
					if (garden[i][j][3] == 1 && rand.nextDouble() < 0.8) {
						garden[i][j][3] = 0;
					} else if (garden[i][j][3] == 2 && rand.nextDouble() < 0.5) {
						garden[i][j][3] = 0;
					}
					garden[i][j][0] *= 0.7;
				}

				//type 2 spray kills 40% of pest2 and 90% of pest3, but also reduces growth by 10%
				if(type == 2){
					if (garden[i][j][3] == 2 && rand.nextDouble() < 0.4) {
						garden[i][j][3] = 0;
					} else if (garden[i][j][3] == 3 && rand.nextDouble() < 0.9) {
						garden[i][j][3] = 0;
					}
					garden[i][j][0] *= 0.9;
				}
				if(type==4){
					if (garden[i][j][3] == 2) {
						garden[i][j][3] = 0;
					}
				}
				
			}
		}
	}

	public int getpests(){
		int[] pestcount=new int[]{0,0,0,0};
		
		for (int i = 0; i < gardenSize; i++) {
			for (int j = 0; j < gardenSize; j++) {
				pestcount[(int)garden[i][j][3]] +=1;
			}
		}
		if(pestcount[0]<gardenSize*gardenSize*0.7){
			int maxind=1;
			int max=0;
			for(int t=1;t<4;t++){
				if(pestcount[t]>=max){
					maxind=t;
					max=pestcount[t];
				}
			}
			logger.info("pest:" + maxind);
			return maxind;
		}
		else{
			//logger.info(""+pestcount[0]);
			return 0;
		}
	}

	public void updateGarden() {
		
			clearPercepts("monitor");
			clearPercepts("fertilizer");
			clearPercepts("irrigator");
			clearPercepts("pestcontrol");
			belief = Literal.parseLiteral("growth(" + getAverageParam(0) + ")");
			addPercept("monitor", belief);
			belief = Literal.parseLiteral("water(" + getAverageParam(1) + ")");
			addPercept("irrigator", belief);
			belief = Literal.parseLiteral("fertilizer(" + getAverageParam(2) + ")");
			addPercept("fertilizer", belief);
			belief = Literal.parseLiteral("pests(" + getpests() + ")");
			addPercept("pestcontrol", belief);

			belief = Literal.parseLiteral("startVotingforIrrigation");
			addPercept("irrigator", belief);

			for (int i = 0; i < gardenSize; i++) {
				for (int j = 0; j < gardenSize; j++) {

					double growth = garden[i][j][0];
					double water = garden[i][j][1];
					double nutrients = garden[i][j][2];
					double pests = garden[i][j][3];

					// update growth
					double newGrowth = growth * 0.8 + Math.min((growth + 0.1) * 0.4, Math.min(water, nutrients));
					newGrowth = Math.min(Math.max(newGrowth, 0), 1);

					// update water
					double newWater = water - Math.max(newGrowth - growth, 0) / 2 - growth / 8
							+ (rand.nextGaussian() + 1) / 20;
					newWater = Math.min(Math.max(newWater, 0), 1);

					// update nutrients
					double newNutrients = nutrients - Math.max(newGrowth - growth, 0) / 2 - growth / 8
							+ (rand.nextGaussian() + 1) / 20;
					newNutrients = Math.min(Math.max(newNutrients, 0), 1);

					double newPests = pests;
					if (pests != 0) {

						//newGrowth *= 0.5;
						//newWater *= 0.8;
						//newNutrients *= 0.8;
						// chance to kill pests
						if(pests==1){
							if(newWater>=0.6){
								newGrowth*=0.3;
							}
						}
						if(pests==2){
							if(newNutrients>=0.6){
								newGrowth*=0.8;
								newWater *= 0.8;
								newNutrients *= 0.8;
						}
						if(pests==3){
							if(newWater<=0.5){   //if water is high this pest has no effect
								newGrowth*=0.7;
							}
						}
						}
						
						if (rand.nextDouble() > growth + water + nutrients) {
							newPests = 0;
						}
					} else {
						// change to spawn pests
						if (rand.nextDouble() < (water * nutrients)) {
							newPests = rand.nextInt(pestTypes)+1;
						}
					}

					garden[i][j][0] = newGrowth;
					garden[i][j][1] = newWater;
					garden[i][j][2] = newNutrients;
					garden[i][j][3] = newPests;

				}
			}
	

	}

	public class ArrayGridDisplay extends JFrame {
		private final int cellSize = 80;
		private JButton simButton;
		private JButton waterButton;
		private JButton fertilizeButton;
		private JButton spray1Button;
		private JButton spray2Button;
		private JPanel buttonPanel;
		private JPanel mainPanel = new JPanel();
		private JPanel cellContainerPanel = new JPanel();
		// array of colors
		private Color[] colors = { Color.GREEN, Color.BLUE, Color.RED, Color.YELLOW };
		private Border border = BorderFactory.createLineBorder(Color.WHITE, 1);
		private DecimalFormat decimalFormat = new DecimalFormat("#.###");

		public ArrayGridDisplay() {
			initializeUI();
		}

		public void setsimulbtn(boolean b){
			simButton.setEnabled(b);	
		}
		public static Color scaleColor(Color originalColor, double scale) {
			int red = (int) Math.round(originalColor.getRed() * scale);
			int green = (int) Math.round(originalColor.getGreen() * scale);
			int blue = (int) Math.round(originalColor.getBlue() * scale);

			// Ensure that the RGB values are within the valid range of 0-255
			red = Math.min(Math.max(red, 0), 255);
			green = Math.min(Math.max(green, 0), 255);
			blue = Math.min(Math.max(blue, 0), 255);

			return new Color(red, green, blue);
		}

		private void initializeUI() {
			setTitle("Array Grid Display");
			setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
			setResizable(false);

			cellContainerPanel.setLayout(new GridLayout(gardenSize, gardenSize));

			updateGUI();
			simButton = new JButton("Simulate");
			simButton.addActionListener(e -> {
				simButton.setEnabled(false);
				
				
					shouldSignal=false;
					updateGarden();
					updateGUI();
					mainPanel.revalidate();
					
				// update gui
				
			});
			waterButton = new JButton("Water");
			waterButton.addActionListener(e -> {
				water(1);
				// update gui
				updateGUI();
				mainPanel.revalidate();
			});
			fertilizeButton = new JButton("Fertilize");
			fertilizeButton.addActionListener(e -> {
				fertilize(1);
				// update gui
				updateGUI();
				mainPanel.revalidate();
			});
			spray1Button = new JButton("Spray 1");
			spray1Button.addActionListener(e -> {
				spray(1);
				// update gui
				updateGUI();
				mainPanel.revalidate();
			});
			spray2Button = new JButton("kill pest2");
			spray2Button.addActionListener(e -> {
				spray(4);
				// update gui
				updateGUI();
				mainPanel.revalidate();
			});
			buttonPanel = new JPanel();
			buttonPanel.setLayout(new BoxLayout(buttonPanel, BoxLayout.Y_AXIS));
			buttonPanel.add(simButton);
			buttonPanel.add(waterButton);
			buttonPanel.add(fertilizeButton);
			buttonPanel.add(spray1Button);
			buttonPanel.add(spray2Button);
			mainPanel.add(buttonPanel);
			mainPanel.add(cellContainerPanel);
			add(mainPanel);
			pack();
			setLocationRelativeTo(null); // Center the frame on the screen
			setVisible(true);
		}

		public void updateGUI() {
			cellContainerPanel.removeAll();
			for (int i = 0; i < gardenSize; i++) {
				for (int j = 0; j < gardenSize; j++) {
					JPanel cellPanel = new JPanel();
					cellPanel.setPreferredSize(new Dimension(cellSize, cellSize));
					cellPanel.setBackground(Color.WHITE);
					cellPanel.setLayout(new GridLayout(2, 2));
					cellPanel.setBorder(border);

					for (int k = 0; k < 4; k++) {
						JLabel numberLabel = new JLabel(decimalFormat.format(garden[i][j][k]), SwingConstants.CENTER);
						JPanel cellSubPanel = new JPanel();
						cellSubPanel.setPreferredSize(new Dimension(cellSize / 2, cellSize / 2));
						cellSubPanel.setLayout(new BorderLayout());
						numberLabel.setFont(new Font(Font.SANS_SERIF, Font.BOLD, 10));
						// numberLabel.setForeground(colors[k]);
						cellSubPanel.add(numberLabel);
						if (k == 3) {
							if (garden[i][j][k] == 0) {
								numberLabel.setForeground(Color.BLACK);
								cellSubPanel.setBackground(Color.WHITE);
							} else {
								numberLabel.setForeground(Color.BLACK);
								cellSubPanel.setBackground(Color.YELLOW);
							}
						} else {
							Color newColor = scaleColor(colors[k], garden[i][j][k]);
							numberLabel.setForeground(Color.WHITE);
							cellSubPanel.setBackground(newColor);
						}
						cellPanel.add(cellSubPanel);
					}
					cellContainerPanel.add(cellPanel);
				}
			}
			mainPanel.add(cellContainerPanel);
		}
	}

	@Override
	public boolean executeAction(String agName, Structure action) {
		if (action.getFunctor().equals("burn")) {
			addPercept(Literal.parseLiteral("fire"));
			return true;
		} else if (action.getFunctor().equals("run")) {
			addPercept(Literal.parseLiteral("running"));
			return true;
		} else if (action.getFunctor().equals("countvoteIrrigation")) {
			logger.info("counting votes for irritgation");
			countervote += 1;
			this.irrigationvote(Integer.parseInt(action.getTerm(0).toString()), action.getTerm(1).toString());
			if (countervote == 4) {
				int max = 0;
				int maxind = 0;
				for (int i = 0; i < 3; i++) {
					if (max <= votesIrrigation[i]) {
						max = votesIrrigation[i];
						maxind = i;
					}
				}
				logger.info("Option index " + maxind + " wins for irrigation");
				this.water(maxind);
				for (int t=0;t<3;t++) {
					votesIrrigation[t]=0;
				}
				
				
				countervote = 0;
			}
			return true;
		} else if (action.getFunctor().equals("countvoteFertilization")) {
			logger.info("counting votes for fertilization");
			
			countervote += 1;
			this.Fertilizationvote(Integer.parseInt(action.getTerm(0).toString()), action.getTerm(1).toString());
			if (countervote == 4) {
				int max = 0;
				int maxind = 0;
				for (int i = 0; i < 3; i++) {
					if (max <= votesFertilization[i]) {
						max = votesFertilization[i];
						maxind = i;
					}

				}
				logger.info("Option index " + maxind + " wins for fertilization");
				this.fertilize(maxind);
				for (int t=0;t<3;t++) {
					votesFertilization[t]=0;
				}

				countervote = 0;
			}

			return true;
		} else if (action.getFunctor().equals("countvoteSpraying")) {
			logger.info("counting votes for Spraying");
			countervote += 1;
			this.Sprayingvote(Integer.parseInt(action.getTerm(0).toString()), action.getTerm(1).toString());
			if (countervote == 4) {
				int max = 0;
				int maxind = 0;
				for (int i = 0; i < 3; i++) {
					if (max <= votesSparying[i]) {
						max = votesSparying[i];
						maxind = i;
					}

				}
				logger.info("Option index " + maxind + " wins for spraying");
				spray(maxind);
				for (int t=0;t<3;t++) {
					votesSparying[t]=0;
				}
				countervote = 0;
				
				belief = Literal.parseLiteral("startVotingforIrrigation");
				removePercept("irrigator", belief);
				
				gui.setsimulbtn(true);
				logger.info("done");
			}

			return true;
		} else {
			logger.info("executing: " + action + ", but not implemented!");
			return false;
		}
	}

	public void irrigationvote(int weight, String option) {
		if (option.equals("no"))
			votesIrrigation[0] += weight;

		if (option.equals("normal"))
			votesIrrigation[1] += weight;

		if (option.equals("high"))
			votesIrrigation[2] += weight;
	}

	public void Fertilizationvote(int weight, String option) {
		
		if (option.equals( "no"))
			votesFertilization[0] += weight;

		if (option.equals("normal"))
			votesFertilization[1] += weight;

		if (option.equals("high"))
			votesFertilization[2] += weight;
	}

	public void Sprayingvote(int weight, String option) {
		if (option.equals("no"))
			votesSparying[0] += weight;

		if (option.equals("pest1"))
			votesSparying[1] += weight;

		if (option.equals("pest2"))
			votesSparying[2] += weight;
	}

	/** Called before the end of MAS execution */
	@Override
	public void stop() {
		super.stop();
	}
}