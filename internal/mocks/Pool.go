// Code generated by MockGen. DO NOT EDIT.
// Source: interfaces.go

// Package mocks is a generated GoMock package.
package mocks

import (
	context "context"
	reflect "reflect"

	gomock "github.com/golang/mock/gomock"
	pgconn "github.com/jackc/pgconn"
	pgx "github.com/jackc/pgx/v4"
	pgxpool "github.com/jackc/pgx/v4/pgxpool"
)

// MockFakePoolInterface is a mock of FakePoolInterface interface.
type MockFakePoolInterface struct {
	ctrl     *gomock.Controller
	recorder *MockFakePoolInterfaceMockRecorder
}

// MockFakePoolInterfaceMockRecorder is the mock recorder for MockFakePoolInterface.
type MockFakePoolInterfaceMockRecorder struct {
	mock *MockFakePoolInterface
}

// NewMockFakePoolInterface creates a new mock instance.
func NewMockFakePoolInterface(ctrl *gomock.Controller) *MockFakePoolInterface {
	mock := &MockFakePoolInterface{ctrl: ctrl}
	mock.recorder = &MockFakePoolInterfaceMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use.
func (m *MockFakePoolInterface) EXPECT() *MockFakePoolInterfaceMockRecorder {
	return m.recorder
}

// Acquire mocks base method.
func (m *MockFakePoolInterface) Acquire(ctx context.Context) (*pgxpool.Conn, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Acquire", ctx)
	ret0, _ := ret[0].(*pgxpool.Conn)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Acquire indicates an expected call of Acquire.
func (mr *MockFakePoolInterfaceMockRecorder) Acquire(ctx interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Acquire", reflect.TypeOf((*MockFakePoolInterface)(nil).Acquire), ctx)
}

// AcquireAllIdle mocks base method.
func (m *MockFakePoolInterface) AcquireAllIdle(ctx context.Context) []*pgxpool.Conn {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "AcquireAllIdle", ctx)
	ret0, _ := ret[0].([]*pgxpool.Conn)
	return ret0
}

// AcquireAllIdle indicates an expected call of AcquireAllIdle.
func (mr *MockFakePoolInterfaceMockRecorder) AcquireAllIdle(ctx interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "AcquireAllIdle", reflect.TypeOf((*MockFakePoolInterface)(nil).AcquireAllIdle), ctx)
}

// AcquireFunc mocks base method.
func (m *MockFakePoolInterface) AcquireFunc(ctx context.Context, f func(*pgxpool.Conn) error) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "AcquireFunc", ctx, f)
	ret0, _ := ret[0].(error)
	return ret0
}

// AcquireFunc indicates an expected call of AcquireFunc.
func (mr *MockFakePoolInterfaceMockRecorder) AcquireFunc(ctx, f interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "AcquireFunc", reflect.TypeOf((*MockFakePoolInterface)(nil).AcquireFunc), ctx, f)
}

// Begin mocks base method.
func (m *MockFakePoolInterface) Begin(ctx context.Context) (pgx.Tx, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Begin", ctx)
	ret0, _ := ret[0].(pgx.Tx)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Begin indicates an expected call of Begin.
func (mr *MockFakePoolInterfaceMockRecorder) Begin(ctx interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Begin", reflect.TypeOf((*MockFakePoolInterface)(nil).Begin), ctx)
}

// BeginFunc mocks base method.
func (m *MockFakePoolInterface) BeginFunc(ctx context.Context, f func(pgx.Tx) error) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "BeginFunc", ctx, f)
	ret0, _ := ret[0].(error)
	return ret0
}

// BeginFunc indicates an expected call of BeginFunc.
func (mr *MockFakePoolInterfaceMockRecorder) BeginFunc(ctx, f interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "BeginFunc", reflect.TypeOf((*MockFakePoolInterface)(nil).BeginFunc), ctx, f)
}

// BeginTx mocks base method.
func (m *MockFakePoolInterface) BeginTx(ctx context.Context, txOptions pgx.TxOptions) (pgx.Tx, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "BeginTx", ctx, txOptions)
	ret0, _ := ret[0].(pgx.Tx)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// BeginTx indicates an expected call of BeginTx.
func (mr *MockFakePoolInterfaceMockRecorder) BeginTx(ctx, txOptions interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "BeginTx", reflect.TypeOf((*MockFakePoolInterface)(nil).BeginTx), ctx, txOptions)
}

// BeginTxFunc mocks base method.
func (m *MockFakePoolInterface) BeginTxFunc(ctx context.Context, txOptions pgx.TxOptions, f func(pgx.Tx) error) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "BeginTxFunc", ctx, txOptions, f)
	ret0, _ := ret[0].(error)
	return ret0
}

// BeginTxFunc indicates an expected call of BeginTxFunc.
func (mr *MockFakePoolInterfaceMockRecorder) BeginTxFunc(ctx, txOptions, f interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "BeginTxFunc", reflect.TypeOf((*MockFakePoolInterface)(nil).BeginTxFunc), ctx, txOptions, f)
}

// Close mocks base method.
func (m *MockFakePoolInterface) Close() {
	m.ctrl.T.Helper()
	m.ctrl.Call(m, "Close")
}

// Close indicates an expected call of Close.
func (mr *MockFakePoolInterfaceMockRecorder) Close() *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Close", reflect.TypeOf((*MockFakePoolInterface)(nil).Close))
}

// Config mocks base method.
func (m *MockFakePoolInterface) Config() *pgxpool.Config {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Config")
	ret0, _ := ret[0].(*pgxpool.Config)
	return ret0
}

// Config indicates an expected call of Config.
func (mr *MockFakePoolInterfaceMockRecorder) Config() *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Config", reflect.TypeOf((*MockFakePoolInterface)(nil).Config))
}

// Connect mocks base method.
func (m *MockFakePoolInterface) Connect(ctx context.Context, connString string) (*pgxpool.Pool, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Connect", ctx, connString)
	ret0, _ := ret[0].(*pgxpool.Pool)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Connect indicates an expected call of Connect.
func (mr *MockFakePoolInterfaceMockRecorder) Connect(ctx, connString interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Connect", reflect.TypeOf((*MockFakePoolInterface)(nil).Connect), ctx, connString)
}

// CopyFrom mocks base method.
func (m *MockFakePoolInterface) CopyFrom(ctx context.Context, tableName pgx.Identifier, columnNames []string, rowSrc pgx.CopyFromSource) (int64, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "CopyFrom", ctx, tableName, columnNames, rowSrc)
	ret0, _ := ret[0].(int64)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// CopyFrom indicates an expected call of CopyFrom.
func (mr *MockFakePoolInterfaceMockRecorder) CopyFrom(ctx, tableName, columnNames, rowSrc interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "CopyFrom", reflect.TypeOf((*MockFakePoolInterface)(nil).CopyFrom), ctx, tableName, columnNames, rowSrc)
}

// Exec mocks base method.
func (m *MockFakePoolInterface) Exec(ctx context.Context, sql string, arguments ...interface{}) (pgconn.CommandTag, error) {
	m.ctrl.T.Helper()
	varargs := []interface{}{ctx, sql}
	for _, a := range arguments {
		varargs = append(varargs, a)
	}
	ret := m.ctrl.Call(m, "Exec", varargs...)
	ret0, _ := ret[0].(pgconn.CommandTag)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Exec indicates an expected call of Exec.
func (mr *MockFakePoolInterfaceMockRecorder) Exec(ctx, sql interface{}, arguments ...interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	varargs := append([]interface{}{ctx, sql}, arguments...)
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Exec", reflect.TypeOf((*MockFakePoolInterface)(nil).Exec), varargs...)
}

// Ping mocks base method.
func (m *MockFakePoolInterface) Ping(ctx context.Context) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Ping", ctx)
	ret0, _ := ret[0].(error)
	return ret0
}

// Ping indicates an expected call of Ping.
func (mr *MockFakePoolInterfaceMockRecorder) Ping(ctx interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Ping", reflect.TypeOf((*MockFakePoolInterface)(nil).Ping), ctx)
}

// Query mocks base method.
func (m *MockFakePoolInterface) Query(ctx context.Context, sql string, args ...interface{}) (pgx.Rows, error) {
	m.ctrl.T.Helper()
	varargs := []interface{}{ctx, sql}
	for _, a := range args {
		varargs = append(varargs, a)
	}
	ret := m.ctrl.Call(m, "Query", varargs...)
	ret0, _ := ret[0].(pgx.Rows)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Query indicates an expected call of Query.
func (mr *MockFakePoolInterfaceMockRecorder) Query(ctx, sql interface{}, args ...interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	varargs := append([]interface{}{ctx, sql}, args...)
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Query", reflect.TypeOf((*MockFakePoolInterface)(nil).Query), varargs...)
}

// QueryFunc mocks base method.
func (m *MockFakePoolInterface) QueryFunc(ctx context.Context, sql string, args, scans []interface{}, f func(pgx.QueryFuncRow) error) (pgconn.CommandTag, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "QueryFunc", ctx, sql, args, scans, f)
	ret0, _ := ret[0].(pgconn.CommandTag)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// QueryFunc indicates an expected call of QueryFunc.
func (mr *MockFakePoolInterfaceMockRecorder) QueryFunc(ctx, sql, args, scans, f interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "QueryFunc", reflect.TypeOf((*MockFakePoolInterface)(nil).QueryFunc), ctx, sql, args, scans, f)
}

// QueryRow mocks base method.
func (m *MockFakePoolInterface) QueryRow(ctx context.Context, sql string, args ...interface{}) pgx.Row {
	m.ctrl.T.Helper()
	varargs := []interface{}{ctx, sql}
	for _, a := range args {
		varargs = append(varargs, a)
	}
	ret := m.ctrl.Call(m, "QueryRow", varargs...)
	ret0, _ := ret[0].(pgx.Row)
	return ret0
}

// QueryRow indicates an expected call of QueryRow.
func (mr *MockFakePoolInterfaceMockRecorder) QueryRow(ctx, sql interface{}, args ...interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	varargs := append([]interface{}{ctx, sql}, args...)
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "QueryRow", reflect.TypeOf((*MockFakePoolInterface)(nil).QueryRow), varargs...)
}

// SendBatch mocks base method.
func (m *MockFakePoolInterface) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "SendBatch", ctx, b)
	ret0, _ := ret[0].(pgx.BatchResults)
	return ret0
}

// SendBatch indicates an expected call of SendBatch.
func (mr *MockFakePoolInterfaceMockRecorder) SendBatch(ctx, b interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "SendBatch", reflect.TypeOf((*MockFakePoolInterface)(nil).SendBatch), ctx, b)
}

// Stat mocks base method.
func (m *MockFakePoolInterface) Stat() *pgxpool.Stat {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Stat")
	ret0, _ := ret[0].(*pgxpool.Stat)
	return ret0
}

// Stat indicates an expected call of Stat.
func (mr *MockFakePoolInterfaceMockRecorder) Stat() *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Stat", reflect.TypeOf((*MockFakePoolInterface)(nil).Stat))
}
