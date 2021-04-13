// EditorDpimDlg.cpp : implementation file
//

#include "stdafx.h"
#include "EditorDpim.h"
#include "EditorDpimDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CEditorDpimDlg dialog

CEditorDpimDlg::CEditorDpimDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CEditorDpimDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CEditorDpimDlg)
	m_sFileName = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CEditorDpimDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CEditorDpimDlg)
	DDX_Control(pDX, IDC_MESSAGE, m_cMessage);
	DDX_Control(pDX, IDC_PERFORM, m_cPerform);
	DDX_Control(pDX, IDC_SEND, m_cSend);
	DDX_Text(pDX, IDC_EDIT1, m_sFileName);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CEditorDpimDlg, CDialog)
	//{{AFX_MSG_MAP(CEditorDpimDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	ON_BN_CLICKED(IDC_PERFORM, OnPerform)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CEditorDpimDlg message handlers

BOOL CEditorDpimDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here

	m_sFileName = "";
	m_cSend.SetCheck(TRUE);
	m_cMessage.EnableWindow(0);
	m_cMessage.SetWindowText("Ready to send text...");
	
	UpdateData(FALSE);

	ERC erc;
	int idDvc;

	/* DPCUTIL API CALL : DpcInit
	*/
	if (!DpcInit(&erc)) {
		MessageBox("Error initializing device");
		m_cPerform.EnableWindow(FALSE);
		return TRUE;
	}

	/* DPCUTIL API CALL : DvmgGetDefaultDev
	*/
	idDvc = DvmgGetDefaultDev(&erc);
	if (idDvc == -1) {
		MessageBox("No default device");
		m_cPerform.EnableWindow(FALSE);
		return TRUE;
	}
	else {
		/* DPCUTIL API CALL : DvmgGetDevName
		*/
		DvmgGetDevName(idDvc, szDefDvc, &erc);
		strcpy(szDefDvc, szDefDvc);
		return TRUE;
	}

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CEditorDpimDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CEditorDpimDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CEditorDpimDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CEditorDpimDlg::OnBrowse() 
{
	// TODO: Add your control notification handler code here
	
	CFileDialog m_ldFile( m_cSend.GetCheck() == TRUE);

	if (m_ldFile.DoModal() == IDOK) 
	{

		m_sFileName = m_ldFile.GetFileName();

		UpdateData(FALSE);
	}
}

void CEditorDpimDlg::OnPerform() 
{
	// TODO: Add your control notification handler code here

	dpimError = FALSE;

	CFileException ex;
	CStdioFile f;
	unsigned char lines=0;
	CString s;
	int length, i;
	char c;
	unsigned char code;

	if ( m_cSend.GetCheck() == TRUE )
	
	{
		//board to PC
		if (! f.Open( (LPCTSTR) m_sFileName, CFile::modeRead | CFile::typeText, &ex))
		{
			TCHAR szError[128];
			ex.GetErrorMessage(szError, 128, NULL);
			MessageBox(szError);
			return;
		}
		
		DoPutReg(0, 0xff);

		if (dpimError)
		{
			//m_cPerform.EnableWindow(FALSE);
			MessageBox("An error occured while doing the transfer!!!");
			return;
		}
		
		m_cMessage.SetWindowText("Transfer in progress. Do not interrupt!!!");
		UpdateData(FALSE);

		while (!dpimError && lines<51)
		{
			f.ReadString(s);
			s.MakeUpper();

			length = s.GetLength();
			if (length>79) length=79;

			for (i=0; i<length; i++)
			{
				c = s.GetAt(i);
				/*
				if (c == '\t')
				{
					DoPutReg(8, 0);
					DoPutReg(8, 0);
					DoPutReg(8, 0);
					DoPutReg(8, 0);
					length -=3;
				}
				else
				*/
				{
					code = convBoard(c);
					DoPutReg(8, code);
				}
			}

			//length = s.GetLength();
			for (i=length; i<80;i++)
				DoPutReg(8, 0);
			
			lines++;
		}

		m_cMessage.SetWindowText("Transfer completed successfully!");
		UpdateData(FALSE);
		MessageBox("Transfer completed successfully!");

		f.Close();
	}

	else
	{

		//PC to board
		if (! f.Open( (LPCTSTR) m_sFileName, CFile::modeCreate
								| CFile::modeWrite | CFile::typeText, &ex))
		{
			TCHAR szError[128];
			ex.GetErrorMessage(szError, 128, NULL);
			MessageBox(szError);
			return;
		}

		DoGetReg(0);

		if (dpimError)
		{
			//m_cPerform.EnableWindow(FALSE);
			MessageBox("An error occured while doing the transfer!!!");
			return;
		}
		
		for (lines=0; lines<51 && !dpimError; lines++)
		{			
			s = "";
			for (i=0;i<80;i++)
			{
				code = DoGetReg(9);	
				c = convPC(code);
				s += c;
			};
			s += '\n';
			f.WriteString(s);
		}

		MessageBox("Transfer completed successfully!");

		f.Close();
	}

}



void CEditorDpimDlg::DoPutReg(	unsigned char idReg, unsigned char idData)
{

	ERC		erc;
	HANDLE	hif;
	TRID	trid;

	/* DPCUTIL API CALL : DpcOpenData
	*	notice the last parameter is a TRID address.  This is a non-blocking call
	*/
	if (!DpcOpenData(&hif, szDefDvc, &erc, &trid)) {
		//MessageBox("DpcOpenData failed.");
		dpimError = TRUE;
		return;
	}

	/* we must wait for the transaction to be completed before moving on */
	if (!DpcWaitForTransaction(hif, trid, &erc)) {
		DpcCloseData(hif, &erc);
		//MessageBox("DpcOpenData failed.");
		dpimError = TRUE;
		return;
	}

	/* DPCUTIL API CALL : DpcGetReg
	*/
	if (!DpcPutReg(hif, idReg, idData, &erc, NULL)) {
		DpcCloseData(hif,&erc);
		//MessageBox("DpcPutReg failed.");
		dpimError = TRUE;
		return;
	}

	/* DPCUTIL API CALL : DpcGetFirstError
	*/
	erc = DpcGetFirstError(hif);

	if (erc == ercNoError) {
		/* DPCUTIL API CALL : DpcCloseData
		*/
		DpcCloseData(hif, &erc);
		//MessageBox("Complete!  Register set.");
	}
	else{
		/* DPCUTIL API CALL : DpcCloseData
		*/
		DpcCloseData(hif, &erc);
		//MessageBox("An error occured while setting the register.");
		dpimError = TRUE;
	}

}

unsigned char CEditorDpimDlg::DoGetReg(unsigned char idReg)
{

	unsigned char	idData;
	ERC		erc;
	HANDLE	hif;


	/* DPCUTIL API CALL : DpcOpenData 
	*	notice last parameter is set to NULL.  This is a blocking call
	*/
	if (!DpcOpenData(&hif, szDefDvc, &erc, NULL)) {
		//MessageBox("DpcOpenData failed.\n");
		dpimError = TRUE;
		return 0;
	}

	/* DPCUTIL API CALL : DpcGetReg
	*/
	if (!DpcGetReg(hif, idReg, &idData, &erc, NULL)) {
		DpcCloseData(hif,&erc);
		//MessageBox("DpcGetReg failed.\n");
		dpimError = TRUE;
		return 0;
	}

	/* DPCUTIL API CALL : DpcGetFirstError
	*/
	erc = DpcGetFirstError(hif);

	if (erc == ercNoError) {
		/* DPCUTIL API CALL : DpcCloseData
		*/
		DpcCloseData(hif, &erc);
		//char s[50];
		//sprintf(s, "Complete!  Data was received = %d\n", idData);
		//MessageBox(s);
	}
	else{
		/* DPCUTIL API CALL : DpcCloseData
		*/
		DpcCloseData(hif, &erc);
		//MessageBox("An error occured while reading the register.\n");
		dpimError = TRUE;
	}

	return idData;

}

unsigned char CEditorDpimDlg::convBoard(char c)
{
	switch (c)
	{
		case ' ': return 37;
		case ',': return 38;
		case '.': return 39;
		case '/': return 40;
		case ';': return 41;
		case 0x27: return 42;  //'
		case 0x5c: return 43;  //backslash
		case '[': return 44;
		case ']': return 45;
		case '-': return 46;
		case '=': return 47;
		case '`': return 48;
		default: 
			if (c>='A' && c<='Z') 
				return c-64;
			else if (c>='0' && c<='9')
					return c-21;
				 else 
					 return 0;
	}


}

char CEditorDpimDlg::convPC(unsigned char code)
{
	
		switch (code)
	{
		case 37: return ' ';
		case 38: return ',';
		case 39: return '.';
		case 40: return '/';
		case 41: return ';';
		case 42: return 0x27;
		case 43: return 0x5c;
		case 44: return '[';
		case 45: return ']';
		case 46: return '-';
		case 47: return '=';
		case 48: return '`';
		default: 
			if (code>=1 && code<=26) 
				return code+64;
			else if (code>=27 && code<=36)
					return code+21;
				 else 
					 return ' ';
	}
}
