// EditorDpimDlg.h : header file
//

#if !defined(AFX_EDITORDPIMDLG_H__DC785539_79F9_4ADD_A95C_AD0A14FDB2F7__INCLUDED_)
#define AFX_EDITORDPIMDLG_H__DC785539_79F9_4ADD_A95C_AD0A14FDB2F7__INCLUDED_

#include <windows.h>
#include "dpcdefs.h"	/* holds error codes and data types for dpcutil	*/
#include "dpcutil.h"	/* holds declaration of DPCUTIL API calls		*/

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CEditorDpimDlg dialog

class CEditorDpimDlg : public CDialog
{
// Construction
public:
	CEditorDpimDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CEditorDpimDlg)
	enum { IDD = IDD_EDITORDPIM_DIALOG };
	CEdit	m_cMessage;
	CButton	m_cPerform;
	CButton	m_cSend;
	CString	m_sFileName;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CEditorDpimDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	char convPC(unsigned char code);
	unsigned char convBoard(char c);
	BOOL dpimError;
	unsigned char DoGetReg(unsigned char );
	void DoPutReg(unsigned char, unsigned char);
	char szDefDvc[17];
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CEditorDpimDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnBrowse();
	afx_msg void OnPerform();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EDITORDPIMDLG_H__DC785539_79F9_4ADD_A95C_AD0A14FDB2F7__INCLUDED_)
