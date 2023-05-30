package example;

import jason.asSyntax.*;
import jason.environment.*;
import java.util.logging.*;
import java.util.Random;

import javax.swing.*;
import javax.swing.border.Border;
import java.awt.*;
import java.text.DecimalFormat;

public class Env extends Environment {
  /** Called before the MAS execution with the args informed in .mas2j */
	private final int gardenSize = 10;
	private final int paramSize = 4;
	private double[][][] garden = new double[gardenSize][gardenSize][paramSize]; // 0: plant growth, 1: water, 2: nutrients, 3: pests
	private int pestTypes = 3;
	private Random rand = new Random();
	private ArrayGridDisplay gui;
	Literal belief;

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
		//initialize garden
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
		belief = Literal.parseLiteral("pests(" + getAverageParam(3) + ")");
		addPercept("pestcontrol", belief);

	}

	public void updateGarden(){
		for (int i = 0; i < gardenSize; i++) {
			for (int j = 0; j < gardenSize; j++) {
				double growth = garden[i][j][0];
				double water = garden[i][j][1];
				double nutrients = garden[i][j][2];
				double pests = garden[i][j][3];

				//update growth
				double newGrowth = growth * 0.8 + Math.min((growth + 0.1) * 0.4, Math.min(water, nutrients));
				newGrowth = Math.min(Math.max(newGrowth, 0), 1);

				//update water
				double newWater = water - Math.max(newGrowth - growth, 0)/2 - growth / 8 + (rand.nextGaussian() + 1) / 20;
				newWater = Math.min(Math.max(newWater, 0), 1);
				
				//update nutrients
				double newNutrients = nutrients - Math.max(newGrowth - growth, 0)/2 - growth / 8 + (rand.nextGaussian() + 1) / 20;
				newNutrients = Math.min(Math.max(newNutrients, 0), 1);

				double newPests = pests;
				if (pests != 0) {
					
					newGrowth *= 0.5;
					newWater *= 0.8;
					newNutrients *= 0.8;
					// 10% chance to kill pests
					if (rand.nextInt(100) < 10) {
						newPests = 0;
					}
				} else {
					// 5% change to spawn pests
					if (rand.nextInt(100) < 5) {
						newPests = rand.nextInt(pestTypes);
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
		private JPanel mainPanel = new JPanel();
		private JPanel cellContainerPanel = new JPanel();
		//array of colors
		private Color[] colors = {Color.GREEN, Color.BLUE, Color.RED, Color.YELLOW}; 
		private Border border = BorderFactory.createLineBorder(Color.WHITE, 1);
		private DecimalFormat decimalFormat = new DecimalFormat("#.###");
    public ArrayGridDisplay() {
        initializeUI();
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
					updateGarden();
					//update gui
					updateGUI();
					mainPanel.revalidate();
				});
				mainPanel.add(simButton);
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

					for (int k = 0; k < 4; k++){
						JLabel numberLabel = new JLabel(decimalFormat.format(garden[i][j][k]), SwingConstants.CENTER);
						JPanel cellSubPanel = new JPanel();
						cellSubPanel.setPreferredSize(new Dimension(cellSize / 2, cellSize / 2));
						cellSubPanel.setLayout(new BorderLayout());
						numberLabel.setFont(new Font(Font.SANS_SERIF, Font.BOLD, 10));
						//numberLabel.setForeground(colors[k]);
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
		} else {
      return false;
    }
  }

  /** Called before the end of MAS execution */
  @Override
  public void stop() {
    super.stop();
  }
}