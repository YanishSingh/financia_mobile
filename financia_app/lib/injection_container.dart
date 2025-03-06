import 'package:financia_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:financia_app/features/auth/data/datasources/remote_data_source_impl.dart';
import 'package:financia_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:financia_app/features/auth/domain/repositories/auth_repository.dart';
// ----- Auth Layer Dependencies -----
// Import the abstract use cases, but hide the implementation to avoid conflicts.
import 'package:financia_app/features/auth/domain/usecases/auth_usecases.dart'
    hide AuthUseCasesImpl;
// Import the concrete implementation.
import 'package:financia_app/features/auth/domain/usecases/auth_usecases_impl.dart';
import 'package:financia_app/features/auth/presentation/viewmodels/auth_viewmodel.dart';
// ----- Budget Layer Dependencies -----
import 'package:financia_app/features/budget/data/datasources/budget_remote_data_source.dart'
    hide BudgetRemoteDataSourceImpl;
import 'package:financia_app/features/budget/data/datasources/budget_remote_data_source_impl.dart';
import 'package:financia_app/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:financia_app/features/budget/domain/repositories/budget_repository.dart';
import 'package:financia_app/features/budget/domain/usecases/create_budget.dart';
import 'package:financia_app/features/budget/domain/usecases/delete_budget.dart';
import 'package:financia_app/features/budget/domain/usecases/get_budgets.dart';
import 'package:financia_app/features/budget/domain/usecases/update_budget.dart';
import 'package:financia_app/features/budget/presentation/viewmodels/budget_viewmodel.dart';
import 'package:financia_app/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:financia_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:financia_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:financia_app/features/profile/domain/usecases/change_password.dart';
import 'package:financia_app/features/profile/domain/usecases/update_profile.dart';
import 'package:financia_app/features/profile/presentation/viewmodels/profile_viewmodel.dart';
// ----- Transaction Layer Dependencies -----
import 'package:financia_app/features/transaction/data/datasources/transaction_remote_data_source.dart';
import 'package:financia_app/features/transaction/data/datasources/transaction_remote_data_source_impl.dart';
import 'package:financia_app/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:financia_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:financia_app/features/transaction/domain/usecases/add_transaction.dart';
import 'package:financia_app/features/transaction/domain/usecases/add_transaction_impl.dart';
import 'package:financia_app/features/transaction/domain/usecases/delete_transaction.dart';
import 'package:financia_app/features/transaction/domain/usecases/delete_transaction_impl.dart';
import 'package:financia_app/features/transaction/domain/usecases/get_monthly_summary.dart';
import 'package:financia_app/features/transaction/domain/usecases/get_monthly_summary_impl.dart';
import 'package:financia_app/features/transaction/domain/usecases/get_transactions.dart';
import 'package:financia_app/features/transaction/domain/usecases/get_transactions_impl.dart';
import 'package:financia_app/features/transaction/domain/usecases/update_transaction.dart';
import 'package:financia_app/features/transaction/domain/usecases/update_transaction_impl.dart';
import 'package:financia_app/features/transaction/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/profile/data/datasources/profile_remote_data_source.dart';

final GetIt sl = GetIt.instance;

void init() {
  // Register an HTTP client as a singleton.
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // ------------------------
  // Auth Layer Registration
  // ------------------------

  // Data Source for Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => RemoteDataSourceImpl());

  // Repository for Auth
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()));

  // Use Cases for Auth
  sl.registerLazySingleton<AuthUseCases>(
      () => AuthUseCasesImpl(authRepository: sl()));

  // View Model for Auth
  sl.registerFactory(() => AuthViewModel(sl<AuthUseCases>()));

  // ------------------------------
  // Transaction Layer Registration
  // ------------------------------

  // Data Source for Transactions
  sl.registerLazySingleton<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSourceImpl(client: sl<http.Client>()));

  // Repository for Transactions
  sl.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(remoteDataSource: sl()));

  // Use Cases for Transactions
  sl.registerLazySingleton<AddTransaction>(
      () => AddTransactionImpl(transactionRepository: sl()));
  sl.registerLazySingleton<GetTransactions>(
      () => GetTransactionsImpl(transactionRepository: sl()));
  sl.registerLazySingleton<UpdateTransaction>(
      () => UpdateTransactionImpl(transactionRepository: sl()));
  sl.registerLazySingleton<DeleteTransaction>(
      () => DeleteTransactionImpl(transactionRepository: sl()));
  sl.registerLazySingleton<GetMonthlySummary>(
      () => GetMonthlySummaryImpl(transactionRepository: sl()));

  // View Model for Transactions
  sl.registerFactory(() => TransactionViewModel(
        getTransactionsUseCase: sl<GetTransactions>(),
        addTransactionUseCase: sl<AddTransaction>(),
        updateTransactionUseCase: sl<UpdateTransaction>(),
        deleteTransactionUseCase: sl<DeleteTransaction>(),
        getMonthlySummaryUseCase: sl<GetMonthlySummary>(),
      ));

  // ------------------------------
  // Budget Layer Registration
  // ------------------------------

  // Data Source for Budgets
  sl.registerLazySingleton<BudgetRemoteDataSource>(
      () => BudgetRemoteDataSourceImpl(client: sl<http.Client>()));

  // Repository for Budgets
  sl.registerLazySingleton<BudgetRepository>(
      () => BudgetRepositoryImpl(remoteDataSource: sl()));

  // Use Cases for Budgets
  sl.registerLazySingleton<CreateBudget>(
      () => CreateBudget(sl<BudgetRepository>()));
  sl.registerLazySingleton<GetBudgets>(
      () => GetBudgets(sl<BudgetRepository>()));
  sl.registerLazySingleton<UpdateBudget>(
      () => UpdateBudget(sl<BudgetRepository>()));
  sl.registerLazySingleton<DeleteBudget>(
      () => DeleteBudget(sl<BudgetRepository>()));

  // View Model for Budgets
  sl.registerFactory(() => BudgetViewModel(
        getBudgetsUseCase: sl<GetBudgets>(),
        createBudgetUseCase: sl<CreateBudget>(),
        updateBudgetUseCase: sl<UpdateBudget>(),
        deleteBudgetUseCase: sl<DeleteBudget>(),
      ));

  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: sl<http.Client>()));
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<UpdateProfile>(
      () => UpdateProfile(sl<ProfileRepository>()));
  sl.registerLazySingleton<ChangePassword>(
      () => ChangePassword(sl<ProfileRepository>()));
  sl.registerFactory(() => ProfileViewModel(
        updateProfileUseCase: sl<UpdateProfile>(),
        changePasswordUseCase: sl<ChangePassword>(),
      ));
}
