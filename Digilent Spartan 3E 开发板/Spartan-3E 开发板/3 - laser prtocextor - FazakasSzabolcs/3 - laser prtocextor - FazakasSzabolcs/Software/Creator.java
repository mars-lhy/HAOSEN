


import java.awt.*;
import java.awt.event.*;
import java.io.*;



class Creator extends Frame implements TextListener, ActionListener,AdjustmentListener,MouseListener {
	
	private TextField nume,file,nr;
	private Button connect,save,copy,clear,left,right,up,down;
	private Scrollbar scroll;
	private Label frames;
	public Label a[]=new Label[256];
	File fisier;
	FileOutputStream outstream;
	FileInputStream instream;
	private int metod=0;
	String fisierul;
	public char data[] = new char[16384];
	int prescroll=0;
	
	
	
	public Creator(String titlu) {
		super(titlu);
		this.addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		});
		
	}

	public void initializare() {
		
		setBackground(Color.lightGray);
		setLayout(null);
		
		scroll = new Scrollbar(Scrollbar.HORIZONTAL, 0, 1, 0, 256);
		scroll.setBounds(300,250,300,25);
		
		nume = new TextField("save.txt", 12);
		nume.setBounds(80,220,180,25);
		
		file = new TextField("save.txt", 12);
		file.setBounds(80,250,105,25);
		
		nr = new TextField("1", 3);
		nr.setBounds(650,220,30,25);
		
		connect = new Button("Load");
		connect.setActionCommand("Load");
		connect.setEnabled(true);
		connect.setBounds(10,220,60,25);
		
		save = new Button("Save");
		save.setActionCommand("Save");
		save.setEnabled(true);
		save.setBounds(10,250,60,25);
		
		copy = new Button("Copy image to frame");
		copy.setActionCommand("Copy");
		copy.setEnabled(true);
		copy.setBounds(500,220,150,25);
		
		clear = new Button("Clear");
		clear.setActionCommand("Clear");
		clear.setEnabled(true);
		clear.setBounds(700,40,50,25);
		
		left = new Button("Left");
		left.setActionCommand("Left");
		left.setEnabled(true);
		left.setBounds(685,110,50,25);
		
		right = new Button("Right");
		right.setActionCommand("Right");
		right.setEnabled(true);
		right.setBounds(745,110,50,25);
		
		up = new Button("Up");
		up.setActionCommand("Up");
		up.setEnabled(true);
		up.setBounds(715,80,50,25);
		
		down = new Button("Down");
		down.setActionCommand("Down");
		down.setEnabled(true);
		down.setBounds(715,140,50,25);
		
		for(int i=7;i>=0;i--)
			for(int j=31;j>=0;j--){
				a[i*32+j]=new Label();
				a[i*32+j].setBackground(Color.gray);
				a[i*32+j].setBounds(10+j*21,40+i*21,20,20);
				add(a[i*32+j]);
				a[i*32+j].addMouseListener(this);
			}
		frames=new Label("Frame number: "+scroll.getValue());
		frames.setBackground(Color.lightGray);
		frames.setBounds(300,220,150,25);
		
		add(frames);
		add(nume);
		add(file);
		add(nr);
		add(scroll);
		add(connect);
		add(save);
		add(copy);
		add(clear);
		add(left);
		add(right);
		add(up);
		add(down);

		

		pack();
		setSize(800, 400);
		
		nume.addTextListener(this);
		file.addTextListener(this);
		scroll.addAdjustmentListener(this);
		connect.addActionListener(this);
		save.addActionListener(this);
		copy.addActionListener(this);
		clear.addActionListener(this);
		left.addActionListener(this);
		right.addActionListener(this);
		up.addActionListener(this);
		down.addActionListener(this);
		
		//cream fisierul
		
			for(int i=0;i<16384;i++)
		data[i]='0';
			desenare();
			//System.out.println(data[5]);
			
		
		
	}	
	
	//mouse listener
	public void mouseClicked(MouseEvent e){}
	public void mousePressed(MouseEvent e){
		if (e.getComponent().getBackground().equals(Color.gray))
			e.getComponent().setBackground(Color.red);	
	else
		e.getComponent().setBackground(Color.gray);
		}
	public void mouseReleased(MouseEvent e){}
	
	public void mouseEntered(MouseEvent e){
		if(e.getModifiersEx()==1024)
			e.getComponent().setBackground(Color.red);	
		if(e.getModifiersEx()==4096)
			e.getComponent().setBackground(Color.gray);}
	
	public void mouseExited(MouseEvent e){}
	
	//scroll listener
	public void adjustmentValueChanged(AdjustmentEvent e) {
		frames.setText("Frame number: "+scroll.getValue());
		scriere();
		prescroll=scroll.getValue();
		desenare();
		Integer x=new Integer(scroll.getValue()+1);
		nr.setText(x.toString());
		
		
	}
	//metoda interfetei TextListener
	public void textValueChanged(TextEvent e) {
		if (file.getText().length() == 0)
			save.setEnabled(false);
		else
			save.setEnabled(true);
		if (nume.getText().length() == 0)
			connect.setEnabled(false);
		else
			connect.setEnabled(true);
		
	}

	//metoda interfetei ActionListener
	public void actionPerformed(ActionEvent e) {
		String command = e.getActionCommand();
		if (command.equals("Save"))
        {
			scriere();
			String continut = file.getText();
			int len = continut.length();
			char buffer[] = new char[len];

				try {
					FileWriter out = new FileWriter(file.getText());
					continut.getChars(0, len-1, buffer, 0);
					for(int j=0;j<4;j++)
					for(int i=0;i<64;i++){
						out.write("INIT_");
						if(i<16)
							out.write('0');
						out.write(Integer.toHexString(i));
						out.write(" => X\"");
						out.write(data,j*4096+i*64,64);
						out.write("\",\n");
					}
					out.close();
					
				} 
				catch(IOException ex) {
					ex.printStackTrace();
				} 		
        } 
		if (command.equals("Load")){
			

				try {
					
					instream = new FileInputStream( nume.getText() );
					
					
					byte[] temp=new byte[64];
					
					for(int j=0;j<4;j++)
					for(int i=0;i<64;i++){
						
				
						instream.skip(13);
						instream.read(temp,0,64);
						System.out.println((char)temp[13]);
						for(int k=0;k<64;k++)
							data[j*4096+i*64+k]=(char)temp[k];
						instream.skip(3);	
						
					}
					instream.close();
					}
				catch(IOException ex) {
					ex.printStackTrace();
				} 	
				desenare();
		}
		if (command.equals("Copy")){
			
			Integer x=new Integer(nr.getText());
			if(x.intValue()<256){
				scriere();
				for(int i=0;i<64;i++)
					data[x.intValue()*64+i]=data[scroll.getValue()*64+i];
				prescroll=x.intValue();
				scroll.setValue(x.intValue());
				frames.setText("Frame number: "+scroll.getValue());
				desenare();
				x=new Integer(scroll.getValue()+1);
				nr.setText(x.toString());
				}
		}
		if (command.equals("Clear")){
			for(int i=7;i>=0;i--)
				for(int j=31;j>=0;j--)
					a[i*32+j].setBackground(Color.gray);
					
				
		}
		if (command.equals("Left")){
			for(int i=7;i>=0;i--)
				for(int j=1;j<=31;j++)
					a[i*32+j-1].setBackground(a[i*32+j].getBackground());
		}
		if (command.equals("Right")){
			for(int i=7;i>=0;i--)
				for(int j=31;j>0;j--)
					a[i*32+j].setBackground(a[i*32+j-1].getBackground());
		}
		if (command.equals("Up")){
			for(int i=1;i<=7;i++)
				for(int j=31;j>0;j--)
					a[(i-1)*32+j].setBackground(a[i*32+j].getBackground());
		}
		if (command.equals("Down")){
			for(int i=7;i>0;i--)
				for(int j=31;j>0;j--)
					a[i*32+j].setBackground(a[(i-1)*32+j].getBackground());
		}
		
	}
	
	public void scriere(){
		
		for(int i=0;i<8;i++)
			for(int j=0;j<8;j++)
		{
			if(	a[4*(i*8+j)].getBackground().equals(Color.gray) && a[4*(i*8+j)+1].getBackground().equals(Color.gray) && a[4*(i*8+j)+2].getBackground().equals(Color.gray) && a[4*(i*8+j)+3].getBackground().equals(Color.gray))
				data[prescroll*64+(7-i)*8+j]='0';
			if(	a[4*(i*8+j)].getBackground().equals(Color.gray) && a[4*(i*8+j)+1].getBackground().equals(Color.gray) && a[4*(i*8+j)+2].getBackground().equals(Color.gray) && a[4*(i*8+j)+3].getBackground().equals(Color.red))
				data[prescroll*64+(7-i)*8+j]='1';
			if(	a[4*(i*8+j)].getBackground().equals(Color.gray) && a[4*(i*8+j)+1].getBackground().equals(Color.gray) && a[4*(i*8+j)+2].getBackground().equals(Color.red) && a[4*(i*8+j)+3].getBackground().equals(Color.gray))
				data[prescroll*64+(7-i)*8+j]='2';
			if(	a[4*(i*8+j)].getBackground().equals(Color.gray) && a[4*(i*8+j)+1].getBackground().equals(Color.gray) && a[4*(i*8+j)+2].getBackground().equals(Color.red) && a[4*(i*8+j)+3].getBackground().equals(Color.red))
				data[prescroll*64+(7-i)*8+j]='3';
			if(	a[4*(i*8+j)].getBackground().equals(Color.gray) && a[4*(i*8+j)+1].getBackground().equals(Color.red) && a[4*(i*8+j)+2].getBackground().equals(Color.gray) && a[4*(i*8+j)+3].getBackground().equals(Color.gray))
				data[prescroll*64+(7-i)*8+j]='4';
			if(	a[4*(i*8+j)].getBackground().equals(Color.gray) && a[4*(i*8+j)+1].getBackground().equals(Color.red) && a[4*(i*8+j)+2].getBackground().equals(Color.gray) && a[4*(i*8+j)+3].getBackground().equals(Color.red))
				data[prescroll*64+(7-i)*8+j]='5';
			if(	a[4*(i*8+j)].getBackground().equals(Color.gray) && a[4*(i*8+j)+1].getBackground().equals(Color.red) && a[4*(i*8+j)+2].getBackground().equals(Color.red) && a[4*(i*8+j)+3].getBackground().equals(Color.gray))
				data[prescroll*64+(7-i)*8+j]='6';
			if(	a[4*(i*8+j)].getBackground().equals(Color.gray) && a[4*(i*8+j)+1].getBackground().equals(Color.red) && a[4*(i*8+j)+2].getBackground().equals(Color.red) && a[4*(i*8+j)+3].getBackground().equals(Color.red))
				data[prescroll*64+(7-i)*8+j]='7';
			if(	a[4*(i*8+j)].getBackground().equals(Color.red) && a[4*(i*8+j)+1].getBackground().equals(Color.gray) && a[4*(i*8+j)+2].getBackground().equals(Color.gray) && a[4*(i*8+j)+3].getBackground().equals(Color.gray))
				data[prescroll*64+(7-i)*8+j]='8';
			if(	a[4*(i*8+j)].getBackground().equals(Color.red) && a[4*(i*8+j)+1].getBackground().equals(Color.gray) && a[4*(i*8+j)+2].getBackground().equals(Color.gray) && a[4*(i*8+j)+3].getBackground().equals(Color.red))
				data[prescroll*64+(7-i)*8+j]='9';
			if(	a[4*(i*8+j)].getBackground().equals(Color.red) && a[4*(i*8+j)+1].getBackground().equals(Color.gray) && a[4*(i*8+j)+2].getBackground().equals(Color.red) && a[4*(i*8+j)+3].getBackground().equals(Color.gray))
				data[prescroll*64+(7-i)*8+j]='A';
			if(	a[4*(i*8+j)].getBackground().equals(Color.red) && a[4*(i*8+j)+1].getBackground().equals(Color.gray) && a[4*(i*8+j)+2].getBackground().equals(Color.red) && a[4*(i*8+j)+3].getBackground().equals(Color.red))
				data[prescroll*64+(7-i)*8+j]='B';
			if(	a[4*(i*8+j)].getBackground().equals(Color.red) && a[4*(i*8+j)+1].getBackground().equals(Color.red) && a[4*(i*8+j)+2].getBackground().equals(Color.gray) && a[4*(i*8+j)+3].getBackground().equals(Color.gray))
				data[prescroll*64+(7-i)*8+j]='C';
			if(	a[4*(i*8+j)].getBackground().equals(Color.red) && a[4*(i*8+j)+1].getBackground().equals(Color.red) && a[4*(i*8+j)+2].getBackground().equals(Color.gray) && a[4*(i*8+j)+3].getBackground().equals(Color.red))
				data[prescroll*64+(7-i)*8+j]='D';
			if(	a[4*(i*8+j)].getBackground().equals(Color.red) && a[4*(i*8+j)+1].getBackground().equals(Color.red) && a[4*(i*8+j)+2].getBackground().equals(Color.red) && a[4*(i*8+j)+3].getBackground().equals(Color.gray))
				data[prescroll*64+(7-i)*8+j]='E';
			if(	a[4*(i*8+j)].getBackground().equals(Color.red) && a[4*(i*8+j)+1].getBackground().equals(Color.red) && a[4*(i*8+j)+2].getBackground().equals(Color.red) && a[4*(i*8+j)+3].getBackground().equals(Color.red))
				data[prescroll*64+(7-i)*8+j]='F';
		}
		
		
	}
	
	public void desenare(){
		
		for(int i=0;i<8;i++)
			for(int j=0;j<8;j++)
		{
			if(data[prescroll*64+(7-i)*8+j]=='0'){	
				a[4*(i*8+j)].setBackground(Color.gray);
				a[4*(i*8+j)+1].setBackground(Color.gray);
				a[4*(i*8+j)+2].setBackground(Color.gray);
				a[4*(i*8+j)+3].setBackground(Color.gray);
				}
			if(data[prescroll*64+(7-i)*8+j]=='1'){	
				a[4*(i*8+j)].setBackground(Color.gray);
				a[4*(i*8+j)+1].setBackground(Color.gray);
				a[4*(i*8+j)+2].setBackground(Color.gray);
				a[4*(i*8+j)+3].setBackground(Color.red);
				}
			if(data[prescroll*64+(7-i)*8+j]=='2'){	
				a[4*(i*8+j)].setBackground(Color.gray);
				a[4*(i*8+j)+1].setBackground(Color.gray);
				a[4*(i*8+j)+2].setBackground(Color.red);
				a[4*(i*8+j)+3].setBackground(Color.gray);
				}
			if(data[prescroll*64+(7-i)*8+j]=='3'){	
				a[4*(i*8+j)].setBackground(Color.gray);
				a[4*(i*8+j)+1].setBackground(Color.gray);
				a[4*(i*8+j)+2].setBackground(Color.red);
				a[4*(i*8+j)+3].setBackground(Color.red);
				}
			if(data[prescroll*64+(7-i)*8+j]=='4'){	
				a[4*(i*8+j)].setBackground(Color.gray);
				a[4*(i*8+j)+1].setBackground(Color.red);
				a[4*(i*8+j)+2].setBackground(Color.gray);
				a[4*(i*8+j)+3].setBackground(Color.gray);
				}
			if(data[prescroll*64+(7-i)*8+j]=='5'){	
				a[4*(i*8+j)].setBackground(Color.gray);
				a[4*(i*8+j)+1].setBackground(Color.red);
				a[4*(i*8+j)+2].setBackground(Color.gray);
				a[4*(i*8+j)+3].setBackground(Color.red);
				}
			if(data[prescroll*64+(7-i)*8+j]=='6'){	
				a[4*(i*8+j)].setBackground(Color.gray);
				a[4*(i*8+j)+1].setBackground(Color.red);
				a[4*(i*8+j)+2].setBackground(Color.red);
				a[4*(i*8+j)+3].setBackground(Color.gray);
				}
			if(data[prescroll*64+(7-i)*8+j]=='7'){	
				a[4*(i*8+j)].setBackground(Color.gray);
				a[4*(i*8+j)+1].setBackground(Color.red);
				a[4*(i*8+j)+2].setBackground(Color.red);
				a[4*(i*8+j)+3].setBackground(Color.red);
				}
			if(data[prescroll*64+(7-i)*8+j]=='8'){	
				a[4*(i*8+j)].setBackground(Color.red);
				a[4*(i*8+j)+1].setBackground(Color.gray);
				a[4*(i*8+j)+2].setBackground(Color.gray);
				a[4*(i*8+j)+3].setBackground(Color.gray);
				}
			if(data[prescroll*64+(7-i)*8+j]=='9'){	
				a[4*(i*8+j)].setBackground(Color.red);
				a[4*(i*8+j)+1].setBackground(Color.gray);
				a[4*(i*8+j)+2].setBackground(Color.gray);
				a[4*(i*8+j)+3].setBackground(Color.red);
				}
			if(data[prescroll*64+(7-i)*8+j]=='A'){	
				a[4*(i*8+j)].setBackground(Color.red);
				a[4*(i*8+j)+1].setBackground(Color.gray);
				a[4*(i*8+j)+2].setBackground(Color.red);
				a[4*(i*8+j)+3].setBackground(Color.gray);
				}
			if(data[prescroll*64+(7-i)*8+j]=='B'){	
				a[4*(i*8+j)].setBackground(Color.red);
				a[4*(i*8+j)+1].setBackground(Color.gray);
				a[4*(i*8+j)+2].setBackground(Color.red);
				a[4*(i*8+j)+3].setBackground(Color.red);
				}
			if(data[prescroll*64+(7-i)*8+j]=='C'){	
				a[4*(i*8+j)].setBackground(Color.red);
				a[4*(i*8+j)+1].setBackground(Color.red);
				a[4*(i*8+j)+2].setBackground(Color.gray);
				a[4*(i*8+j)+3].setBackground(Color.gray);
				}
			if(data[prescroll*64+(7-i)*8+j]=='D'){	
				a[4*(i*8+j)].setBackground(Color.red);
				a[4*(i*8+j)+1].setBackground(Color.red);
				a[4*(i*8+j)+2].setBackground(Color.gray);
				a[4*(i*8+j)+3].setBackground(Color.red);
				}
			if(data[prescroll*64+(7-i)*8+j]=='E'){	
				a[4*(i*8+j)].setBackground(Color.red);
				a[4*(i*8+j)+1].setBackground(Color.red);
				a[4*(i*8+j)+2].setBackground(Color.red);
				a[4*(i*8+j)+3].setBackground(Color.gray);
				}
			if(data[prescroll*64+(7-i)*8+j]=='F'){	
				a[4*(i*8+j)].setBackground(Color.red);
				a[4*(i*8+j)+1].setBackground(Color.red);
				a[4*(i*8+j)+2].setBackground(Color.red);
				a[4*(i*8+j)+3].setBackground(Color.red);
				}
		}
		
		
	}
	
	public static void main(String args[]) {
		Creator f = new Creator("Creator");
		f.initializare();
		f.show();
	}
}
	

