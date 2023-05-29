package example;

import jason.asSyntax.*;
import jason.environment.*;
import java.util.logging.*;
import java.util.Random;

import javax.swing.*;
import javax.swing.border.Border;
import java.awt.*;

public class Env extends Environment {
  /** Called before the MAS execution with the args informed in .mas2j */
	private final int gardenSize = 10;
	private final int paramSize = 4;
	private float[][][] garden = new float[gardenSize][gardenSize][paramSize]; // 0: plant growth, 1: water, 2: fertilizer, 3: pests
	private Random rand = new Random();
	private ArrayGridDisplay gui;
	Literal belief;

	public float getAverageParam(int param) {
		float sum = 0;
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
					if (k == 0)
						garden[i][j][k] = (float)rand.nextInt(2);
					else
						garden[i][j][k] = 0;
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

	public class ArrayGridDisplay extends JFrame {
    private final int cellSize = 70;
		private JButton simButton;
		private JPanel mainPanel = new JPanel();
		private JPanel cellContainerPanel = new JPanel();
		//array of colors
		private Color[] colors = {Color.GREEN, Color.BLUE, Color.BLACK, Color.RED}; 
		private Border border = BorderFactory.createLineBorder(Color.BLACK, 1);
    public ArrayGridDisplay() {
        initializeUI();
    }

    private void initializeUI() {
        setTitle("Array Grid Display");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setResizable(false);

        cellContainerPanel.setLayout(new GridLayout(gardenSize, gardenSize));

        update();
				simButton = new JButton("Simulate");
				simButton.addActionListener(e -> {
					for (int i = 0; i < gardenSize; i++) {
						for (int j = 0; j < gardenSize; j++) {
							garden[i][j][0] = (float)rand.nextInt(2);
						}
					}
					//update gui
					update();
					mainPanel.revalidate();
				});
				mainPanel.add(simButton);
				mainPanel.add(cellContainerPanel);
        add(mainPanel);
        pack();
        setLocationRelativeTo(null); // Center the frame on the screen
        setVisible(true);
    }

		public void update() {
			cellContainerPanel.removeAll();
			for (int i = 0; i < gardenSize; i++) {
				for (int j = 0; j < gardenSize; j++) {
					JPanel cellPanel = new JPanel();
					cellPanel.setPreferredSize(new Dimension(cellSize, cellSize));
					cellPanel.setBackground(Color.WHITE);
					cellPanel.setLayout(new GridLayout(2, 2));
					cellPanel.setBorder(border);

					for (int k = 0; k < 4; k++){
						JLabel numberLabel = new JLabel(String.valueOf(garden[i][j][k]), SwingConstants.CENTER);
						numberLabel.setFont(new Font(Font.SANS_SERIF, Font.BOLD, 10));
						numberLabel.setForeground(colors[k]);
						cellPanel.add(numberLabel);
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